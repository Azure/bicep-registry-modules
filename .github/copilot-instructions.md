# GitHub Copilot Instructions for AVM Development

> These instructions are automatically loaded by GitHub Copilot when working in this repository.

---

## AVM Spec-Kit Integration

This repository uses [AVM Spec-Kit](https://github.com/FallenHoot/avm-spec-kit) for AI-assisted AVM development.

**To load AVM rules and best practices:**
1. Read the constitution from the spec-kit: [FallenHoot/avm-spec-kit/.specify/memory/constitution.md](https://github.com/FallenHoot/avm-spec-kit/blob/main/.specify/memory/constitution.md)
2. For local development, run `specify init` to generate `.specify/` locally

The spec-kit constitution contains comprehensive rules for:
- Module classification (RES/PTN/UTL)
- Parameter naming and decorators (BCPNFR)
- Test scenario requirements
- CI/CD validation rules
- Git workflow and PR process

---

## Module Context

**Current Focus**: `avm/ptn/finops-toolkit/finops-hub` - FinOps Hub pattern module

| Path | Type | Description |
|------|------|-------------|
| `avm/res/*` | Resource Module | Single Azure resource with extensions |
| `avm/ptn/*` | Pattern Module | Multi-resource deployment scenarios |
| `avm/utl/*` | Utility Module | Helper functionality (no Azure resources) |

---

## Quick Reference

### Pre-Push Checklist

- [ ] `bicep build main.bicep --outfile main.json` - ARM template regenerated
- [ ] `Set-ModuleReadMe` run if parameters changed - README updated
- [ ] No `//` comments in PowerShell deployment scripts (use `#`)
- [ ] Line endings are LF (not CRLF)
- [ ] Pushing to **fork** remote, not origin

### Common CI Failures

| Error | Fix |
|-------|-----|
| `main.json should be based on main.bicep` | Run `bicep build main.bicep --outfile main.json` |
| `The term '//' is not recognized` | Change `//` to `#` in PowerShell scripts |
| `Set-ModuleReadMe should not apply updates` | Run `Set-ModuleReadMe -TemplateFilePath main.bicep` |
| `VaultAlreadyExists` | Add `deploymentSuffix` to hubName |
| `SkuNotAvailable` | Use `enforcedLocation = 'italynorth'` |

---

## References

- [AVM Spec-Kit (Constitution)](https://github.com/FallenHoot/avm-spec-kit)
- [AVM Specifications](https://azure.github.io/Azure-Verified-Modules/specs/)
- [Bicep Registry Modules](https://github.com/Azure/bicep-registry-modules)
- [FinOps Toolkit](https://github.com/microsoft/finops-toolkit)
- [Architecture Decision Records](https://learn.microsoft.com/azure/well-architected/architect-role/architecture-decision-record)
- [ADR Templates (adr.github.io)](https://adr.github.io/)
