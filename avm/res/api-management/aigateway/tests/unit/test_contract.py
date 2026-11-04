"""Offline checks for the review draft's compiled ARM contract."""

import json
import re
import subprocess
import tempfile
import unittest
from pathlib import Path


MODULE = Path(__file__).resolve().parents[2]
REPOSITORY = MODULE.parents[3]
API_VERSION = "2025-09-01-preview"
PREFIX = "Microsoft.ApiManagement/aigateways"


def templates(template):
    yield template
    resources = template.get("resources", {})
    entries = resources.values() if isinstance(resources, dict) else resources
    for resource in entries:
        nested = resource.get("properties", {}).get("template") if isinstance(resource.get("properties"), dict) else None
        if nested:
            yield from templates(nested)


def resources(template):
    for nested in templates(template):
        entries = nested.get("resources", {})
        yield from entries.values() if isinstance(entries, dict) else entries


class ContractTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.root = json.loads((MODULE / "main.json").read_text())

    def definition(self, name):
        definition = self.root["definitions"][name]
        while "$ref" in definition:
            definition = self.root["definitions"][definition["$ref"].split("/")[-1]]
        return definition

    def resource(self, resource_type):
        matches = [
            resource
            for resource in resources(self.root)
            if resource["type"] == resource_type and not resource.get("existing", False)
        ]
        self.assertEqual(len(matches), 1, resource_type)
        return matches[0]

    def test_standalone_preview_and_sku(self):
        gateway = self.resource(PREFIX)
        self.assertEqual(gateway["apiVersion"], API_VERSION)
        self.assertEqual(
            gateway["sku"],
            "[if(equals(parameters('sku'), null()), null(), createObject('name', parameters('sku')))]",
        )
        self.assertEqual(
            self.root["parameters"]["sku"]["allowedValues"],
            ["Standard"],
        )
        self.assertTrue(self.root["parameters"]["sku"]["nullable"])
        self.assertNotIn("defaultValue", self.root["parameters"]["sku"])
        serialized = json.dumps(self.root)
        self.assertNotIn("Microsoft.Web/connectorGateways", serialized)
        self.assertNotIn("Microsoft.ApiManagement/service", serialized)
        for resource in resources(self.root):
            if resource["type"].startswith(PREFIX):
                self.assertEqual(resource["apiVersion"], API_VERSION)

    def test_default_identity_workspace_and_hostname(self):
        self.assertEqual(self.root["parameters"]["managedIdentities"]["defaultValue"], {"systemAssigned": True})
        self.assertEqual(self.root["parameters"]["workspaces"]["defaultValue"], [{"name": "default"}])
        self.assertEqual(self.root["parameters"]["workspaces"]["maxLength"], 1)
        workspace = self.definition("workspaceType")
        self.assertEqual(workspace["properties"]["name"]["allowedValues"], ["default"])
        policy_write = self.resource(f"{PREFIX}/workspaces")
        self.assertEqual(policy_write["condition"], "[not(equals(parameters('policies'), null()))]")
        self.assertEqual(policy_write["properties"], {"policies": "[parameters('policies')]"})
        self.assertEqual(
            self.root["outputs"]["defaultHostname"]["value"],
            "[reference('gateway').frontend.defaultHostname]",
        )

    def test_exports_are_typed_and_sealed(self):
        expected = {
            "apiKeyType", "workspaceType", "modelProviderType", "authenticationType",
            "modelType", "policyType", "tokenLimitPolicyType", "costLimitPolicyType",
            "contentSafetyPolicyType", "ipFilterPolicyType", "aliasType", "routeType",
            "toolServerType", "toolEndpointType", "telemetryExporterType",
            "virtualNetworkConfigurationType",
        }
        exported = {
            name for name, schema in self.root["definitions"].items()
            if schema.get("metadata", {}).get("__bicep_export!")
        }
        self.assertEqual(exported, expected)
        for name in expected:
            schema = self.definition(name)
            self.assertEqual(schema["type"], "object", name)
            if "discriminator" not in schema:
                self.assertIs(schema["additionalProperties"], False, name)

    def test_routes_have_preview_fields_and_bounds(self):
        alias = self.resource(f"{PREFIX}/workspaces/aliases")
        routing = alias["properties"]["copy"][0]
        self.assertEqual(routing["name"], "backendModels")
        self.assertEqual(set(routing["input"]), {"resourceId", "priority", "weight"})
        self.assertIn("coalesce", routing["input"]["priority"])
        self.assertIn(", 0)", routing["input"]["priority"])
        self.assertIn(", 1)", routing["input"]["weight"])
        schema = self.definition("routeType")["properties"]
        self.assertEqual((schema["priority"]["minValue"], schema["priority"]["maxValue"]), (0, 100))
        self.assertEqual((schema["weight"]["minValue"], schema["weight"]["maxValue"]), (1, 100))

    def test_policy_dimensions_and_budgets(self):
        policy = self.definition("policyType")
        self.assertEqual(
            set(policy["discriminator"]["mapping"]),
            {"tokenLimit", "costLimit", "contentSafety", "ipFilter"},
        )
        for name in ("tokenLimitPolicyType", "costLimitPolicyType"):
            dimension = self.definition(name)["properties"]["counterKey"]
            self.assertEqual(dimension["type"], "array")
            self.assertEqual(set(dimension["allowedValues"]), {"identity", "ipAddress"})
            self.assertEqual((dimension["minLength"], dimension["maxLength"]), (1, 2))
        self.assertEqual(self.definition("tokenLimitPolicyType")["properties"]["count"]["minValue"], 1)
        self.assertEqual(self.definition("costLimitPolicyType")["properties"]["amount"]["minValue"], 1)
        ip_filter = self.definition("ipFilterPolicyType")["properties"]
        self.assertEqual(set(ip_filter["action"]["allowedValues"]), {"Allow", "Deny"})
        self.assertEqual(ip_filter["cidrRanges"]["minLength"], 1)

    def test_exporter_kinds_and_boolean_capture_default(self):
        exporter = self.resource(f"{PREFIX}/workspaces/telemetryExporters")
        self.assertIn("'payloadCapture', coalesce(tryGet(parameters('properties'), 'payloadCapture'), false())", exporter["properties"])
        properties = self.definition("telemetryExporterType")["properties"]["properties"]
        schema = self.root["definitions"][properties["$ref"].split("/")[-1]]
        mapping = schema["discriminator"]["mapping"]
        self.assertEqual(set(mapping), {"ApplicationInsights", "OpenTelemetry"})
        for variant in mapping.values():
            variant = self.root["definitions"][variant["$ref"].split("/")[-1]]
            self.assertEqual(variant["properties"]["payloadCapture"]["type"], "bool")

    def test_secrets_remain_secure_through_nested_deployments(self):
        for template in templates(self.root):
            if "secrets" in template.get("parameters", {}):
                self.assertEqual(template["parameters"]["secrets"]["type"], "secureObject")
            for output in template.get("outputs", {}).values():
                self.assertNotIn("parameters('secrets')", json.dumps(output))
        api_key = self.resource(f"{PREFIX}/apiKeys")
        self.assertIn("parameters('secrets')", api_key["properties"])
        self.assertNotIn("listSecrets(", json.dumps(self.root))

    def test_ordering_and_lock_boundary(self):
        root_resources = self.root["resources"]
        self.assertIn("gateway", root_resources["gateway_apiKeys"]["dependsOn"])
        self.assertIn("gateway_apiKeys", root_resources["gateway_workspaces"]["dependsOn"])
        self.assertIn("gateway_workspaces", root_resources["gateway_lock"]["dependsOn"])
        self.assertIn("'CanNotDelete'", root_resources["gateway_lock"]["condition"])
        workspace_template = root_resources["gateway_workspaces"]["properties"]["template"]
        self.assertIn("workspace_modelProviders", workspace_template["resources"]["workspace_aliases"]["dependsOn"])

    def test_scenarios_include_sequential_idempotency(self):
        for scenario in ("defaults", "max", "waf-aligned"):
            template = json.loads((MODULE / "tests/e2e" / scenario / "main.test.json").read_text())
            test = next(
                resource for resource in resources(template)
                if resource.get("copy", {}).get("name") == "testDeployment"
            )
            self.assertEqual(test["copy"]["mode"], "serial")
            self.assertEqual(test["copy"]["batchSize"], 1)
            self.assertIn("createArray('init', 'idem')", test["copy"]["count"])

    def test_readme_examples_compile(self):
        examples = re.findall(r"```bicep\n(.*?)```", (MODULE / "README.md").read_text(), re.S)
        self.assertEqual(len(examples), 2)
        for example in examples:
            with tempfile.TemporaryDirectory(prefix="aigateway-example-", dir=REPOSITORY) as directory:
                source = Path(directory) / "example.bicep"
                source.write_text(example.replace("'./avm/", "'../avm/"))
                result = subprocess.run(
                    ["az", "bicep", "build", "--file", str(source)],
                    capture_output=True, text=True, check=False,
                )
                self.assertEqual(result.returncode, 0, result.stdout + result.stderr)

    def test_invalid_configuration_is_rejected(self):
        cases = [
            ("routeType", "{ providerName: 'foundry', priority: 0 }"),
            ("workspaceType", "{ name: 'unverified-workspace' }"),
            ("tokenLimitPolicyType", "{ type: 'tokenLimit', count: 10, period: 'minute', counterKey: ['Identity'] }"),
            ("aliasType", "{ name: 'chat', properties: { displayName: 'Chat', backendModels: [] } }"),
        ]
        for type_name, value in cases:
            with tempfile.TemporaryDirectory(prefix="aigateway-invalid-", dir=MODULE / "tests/unit") as directory:
                source = Path(directory) / "invalid.bicep"
                source.write_text(
                    f"import {{ {type_name} }} from '../../../main.bicep'\n"
                    f"param configuration {type_name} = {value}\n"
                )
                result = subprocess.run(
                    ["az", "bicep", "build", "--file", str(source)],
                    capture_output=True, text=True, check=False,
                )
                self.assertNotEqual(result.returncode, 0, f"Unexpected acceptance: {value}")
                self.assertNotIn("BCP091", result.stderr, result.stderr)
                self.assertRegex(result.stderr, r"Error BCP(033|034|035|036|037|088|089)", result.stderr)


if __name__ == "__main__":
    unittest.main()
