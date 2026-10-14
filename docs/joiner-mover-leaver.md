Joiner — New employee

HR submits a new hire → IT creates an Entra account → department groups assigned → MFA registration required → access verified.

Mover — Employee changes department

HR approves transfer → old permissions reviewed and removed → new permissions approved and assigned → changes recorded.

Leaver — Employee exits

HR initiates termination → sign-in blocked → sessions revoked → access removed → records retained according to policy.


| Scenario | Employee | IAM Action |
|---|---|---|
| Joiner | New Finance employee | Create account, assign Finance group, require MFA |
| Mover | Susan transfers from Finance to HR | Remove Finance access, assign HR access |
| Leaver | IT employee resigns | Block sign-in, revoke sessions, remove access |

## Workflow Verification

| Scenario | Responsible team | Verification |
|---|---|---|
| Joiner | HR + IAM | Account exists, correct groups assigned, MFA registered |
| Mover | HR + IAM | Previous access removed, new access approved |
| Leaver | HR + IAM | Sign-in blocked, sessions revoked, access removed |
