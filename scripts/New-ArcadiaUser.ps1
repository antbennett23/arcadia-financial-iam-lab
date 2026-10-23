# Arcadia Financial IAM Lab
# New-ArcadiaUser.ps1
# Phase 1: Read-only onboarding validation

$ErrorActionPreference = "Stop"

$requiredScopes = @("User.Read.All", "Group.Read.All")
$context = Get-MgContext

if (-not $context) {
    throw "Connect to Microsoft Graph before running this script."
}

$expectedTenantId = "3300fc49-f10e-4e21-8d0f-2b6daf0718aa"

if ($context.TenantId -ne $expectedTenantId) {
    throw "Incorrect Microsoft Entra tenant. Stopping."
}

foreach ($scope in $requiredScopes) {
    if ($scope -notin $context.Scopes) {
        throw "Missing Microsoft Graph permission: $scope"
    }
}

$departmentGroups = @{
    IT         = "SG-IT-Users"
    Finance    = "SG-Finance-Users"
    HR         = "SG-HR-Users"
    Operations = "SG-Operations-Users"
}

Write-Host "`nArcadia Financial - Identity Inventory" -ForegroundColor Cyan

$users = @(Get-MgUser -All -Property DisplayName,Department,AccountEnabled)
$groups = @(Get-MgGroup -All -Property DisplayName,Id)

foreach ($department in $departmentGroups.Keys) {
    $groupName = $departmentGroups[$department]
    $group = @($groups | Where-Object DisplayName -eq $groupName)

    if ($group.Count -ne 1) {
        throw "Expected exactly one group named $groupName."
    }
}

$users |
    Select-Object DisplayName, Department, AccountEnabled |
    Format-Table -AutoSize

Write-Host "Validated $($users.Count) users and department groups." -ForegroundColor Green
Write-Host "READ-ONLY MODE: No identities or memberships were changed."


# Phase 2: Employee onboarding reconciliation
# Read-only: does not create or modify accounts

$csvPath = "$HOME/arcadia-financial-iam-lab/sample-data/fictional-employees.csv"

if (-not (Test-Path $csvPath)) {
    throw "Employee CSV file not found: $csvPath"
}

$employees = @(
    Get-Content $csvPath |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        ConvertFrom-Csv
)

$requiredColumns = @(
    "FirstName", "LastName", "Department",
    "JobTitle", "SecurityGroup"
)

if ($employees.Count -eq 0) {
    throw "Employee CSV contains no records."
}

foreach ($column in $requiredColumns) {
    if ($column -notin $employees[0].PSObject.Properties.Name) {
        throw "Missing required CSV column: $column"
    }
}

# Use the $users variable retrieved in Phase 1.
if (-not $users) {
    throw "Entra user inventory is empty. Cannot run reconciliation."
}
$report = foreach ($employee in $employees) {

    $fullName = "$($employee.FirstName) $($employee.LastName)"

    $matches = @(
        $users | Where-Object {
            $_.DisplayName -eq $fullName
        }
    )

    $status = if ($matches.Count -gt 1) {
        "Multiple Matches - Review"
    }
    elseif ($matches.Count -eq 0) {
        "Not Found - Review for Onboarding"
    }
    elseif (-not $matches[0].AccountEnabled) {
        "Disabled - Do Not Reactivate"
    }
    elseif ($matches[0].Department -ne $employee.Department) {
        "Department Mismatch - Review"
    }
    else {
        "Existing - No Action"
    }

    [PSCustomObject]@{
        Employee   = $fullName
        Department = $employee.Department
        Group      = $employee.SecurityGroup
        Status     = $status
    }
}
$reportPath = "$HOME/arcadia-financial-iam-lab/reports/onboarding-preview.csv"

New-Item -ItemType Directory -Path (Split-Path $reportPath) -Force |
    Out-Null

$report | Export-Csv -Path $reportPath
Write-Host "`nOnboarding Report Summary" -ForegroundColor Cyan

$report |
    Group-Object Status |
    Select-Object Name,Count |
    Format-Table -AutoSize

Write-Host "Report saved to: $reportPath" -ForegroundColor Green
Write-Host "READ-ONLY MODE: No accounts or groups were changed."


