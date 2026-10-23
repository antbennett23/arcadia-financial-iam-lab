# arcadia-financial-iam-lab
Enterprise IAM lifecycle automation lab for a fictional financial institution
# Arcadia Financial — Identity Lifecycle Management Lab

## Overview
Arcadia Financial is a fictional financial-services organization with 500 employees. This portfolio project demonstrates the design and implementation of secure identity lifecycle management using Microsoft Entra ID, Microsoft Graph, and PowerShell.

## Business Problem
Financial institutions must manage employee access consistently, prevent excessive permissions, and quickly revoke access when employees change roles or leave the organization.

## Project Objectives
- Design role-based access controls
- Automate employee onboarding and offboarding
- Apply least-privilege security principles
- Document joiner-mover-leaver workflows
- Demonstrate and test identity automation

## Technologies
- Microsoft Entra ID
- Microsoft Graph
- PowerShell
- GitHub

## Status
Phase 1: Planning and identity architecture design. No live environment has been deployed yet.

## Microsoft Entra ID — Automated Identity Reconciliation

### Overview
Developed a read-only PowerShell automation workflow using Microsoft Graph to compare fictional HR employee records against identities in Microsoft Entra ID.

### Workflow
1. Authenticate to Microsoft Graph and validate the target tenant.
2. Retrieve existing Entra ID users and security groups.
3. Import and validate a fictional employee CSV.
4. Compare employee records against directory identities.
5. Identify missing accounts, department mismatches, and disabled identities.
6. Export an onboarding reconciliation report for review.

### Lab Results

| Reconciliation Status | Count |
|---|---:|
| Existing accounts — No action | 2 |
| Not found — Onboarding review | 12 |
| Department mismatch — Review | 1 |
| Disabled — Do not reactivate | 1 |
| **Total employees** | **16** |

### Security Considerations
- Read-only execution prevents unintended identity changes.
- Tenant and permission checks validate the execution environment.
- Disabled accounts are flagged rather than automatically reactivated.
- Department discrepancies require review before access changes.
- Display-name matching is used for this introductory lab; production implementations should use unique employee identifiers.

### Portfolio Artifacts
- `scripts/New-ArcadiaUser.ps1` — Identity validation and reconciliation script.
- `reports/onboarding-preview.csv` — Sample reconciliation output.
- `sample-data/fictional-employees.csv` — Fictional HR source records.

**Next phase:** Implement controlled employee provisioning with duplicate prevention, group assignment validation, and dry-run support.
