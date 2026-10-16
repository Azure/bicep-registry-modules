
### Sending server-level audit logs to Azure Monitor

Server-level auditing is configured via the `auditSettings` parameter. However, the resulting audit events (the `SQLSecurityAuditEvents` and `DevOpsOperationsAudit` log categories) are emitted by the server's `master` database and not by the logical server itself. Sending them to a Log Analytics workspace, Event Hub, Storage Account or partner solution therefore requires an additional diagnostic setting scoped to that `master` database, which can be configured via the `masterDatabaseDiagnosticSettings` parameter.

As the `master` database is implicitly created together with the logical server, it cannot be declared via the `databases` parameter.

<details>

<summary>Bicep format</summary>

```bicep
auditSettings: {
    state: 'Enabled'
    isAzureMonitorTargetEnabled: true // Required to forward the audit events to Azure Monitor
    isDevopsAuditEnabled: true // Optional. Only required for the 'DevOpsOperationsAudit' category
}
masterDatabaseDiagnosticSettings: [
    {
        workspaceResourceId: '<logAnalyticsWorkspaceResourceId>'
        logCategoriesAndGroups: [
            {
                category: 'SQLSecurityAuditEvents'
            }
            {
                category: 'DevOpsOperationsAudit'
            }
        ]
    }
]
```

</details>
<p>

> **Note:** The `master` database does not emit any platform metrics. Metrics are hence only configured if explicitly requested via `metricCategories`.

### Parameter Usage: `administrators`

Configure Azure Active Directory Authentication method for server administrator.
<https://learn.microsoft.com/en-us/azure/templates/microsoft.sql/servers/administrators?tabs=bicep>

<details>

<summary>Parameter JSON format</summary>

```json
"administrators": {
    "value": {
        "azureADOnlyAuthentication": true,
        "login": "John Doe", // if application can be anything
        "sid": "[[objectId]]", // if application, the object ID
        "principalType" : "User", // options: "User", "Group", "Application"
        "tenantId": "[[tenantId]]"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
administrators: {
    azureADOnlyAuthentication: true
    login: 'John Doe' // if application can be anything
    sid: '[[objectId]]' // if application the object ID
    'principalType' : 'User' // options: 'User' 'Group' 'Application'
    tenantId: '[[tenantId]]'
}
```

</details>
<p>

