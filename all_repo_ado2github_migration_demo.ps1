#!/usr/bin/env pwsh

# =========== Created with CLI version 1.18.1 ===========

function Exec {
    param (
        [scriptblock]$ScriptBlock
    )
    & @ScriptBlock
    if ($lastexitcode -ne 0) {
        exit $lastexitcode
    }
}

function ExecAndGetMigrationID {
    param (
        [scriptblock]$ScriptBlock
    )
    $MigrationID = & @ScriptBlock | ForEach-Object {
        Write-Host $_
        $_
    } | Select-String -Pattern "\(ID: (.+)\)" | ForEach-Object { $_.matches.groups[1] }
    return $MigrationID
}

function ExecBatch {
    param (
        [scriptblock[]]$ScriptBlocks
    )
    $Global:LastBatchFailures = 0
    foreach ($ScriptBlock in $ScriptBlocks)
    {
        & @ScriptBlock
        if ($lastexitcode -ne 0) {
            $Global:LastBatchFailures++
        }
    }
}

if (-not $env:ADO_PAT) {
    Write-Error "ADO_PAT environment variable must be set to a valid Azure DevOps Personal Access Token with the appropriate scopes. For more information see https://docs.github.com/en/migrations/using-github-enterprise-importer/preparing-to-migrate-with-github-enterprise-importer/managing-access-for-github-enterprise-importer#personal-access-tokens-for-azure-devops"
    exit 1
} else {
    Write-Host "ADO_PAT environment variable is set and will be used to authenticate to Azure DevOps."
}

if (-not $env:GH_PAT) {
    Write-Error "GH_PAT environment variable must be set to a valid GitHub Personal Access Token with the appropriate scopes. For more information see https://docs.github.com/en/migrations/using-github-enterprise-importer/preparing-to-migrate-with-github-enterprise-importer/managing-access-for-github-enterprise-importer#creating-a-personal-access-token-for-github-enterprise-importer"
    exit 1
} else {
    Write-Host "GH_PAT environment variable is set and will be used to authenticate to GitHub."
}

$Succeeded = 0
$Failed = 0
$RepoMigrations = [ordered]@{}

# =========== Queueing migration for Organization: nacoolplayz ===========

# === Queueing repo migrations for Team Project: nacoolplayz/ADO_to_GitHub_migration ===

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ADO_to_GitHub_migration" --ado-repo "ADO_to_GitHub_migration" --github-org "nacoolplayz-org1" --github-repo "ADO_to_GitHub_migration-ADO_to_GitHub_migration" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-ADO_to_GitHub_migration"] = $MigrationID

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ADO_to_GitHub_migration" --ado-repo "Demo_repo_1" --github-org "nacoolplayz-org1" --github-repo "ADO_to_GitHub_migration-Demo_repo_1" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_1"] = $MigrationID

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ADO_to_GitHub_migration" --ado-repo "Demo_repo_2" --github-org "nacoolplayz-org1" --github-repo "ADO_to_GitHub_migration-Demo_repo_2" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_2"] = $MigrationID

# === Queueing repo migrations for Team Project: nacoolplayz/ado_to_github_mig_GEI ===

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ado_to_github_mig_GEI" --ado-repo "ado_to_github_mig_GEI" --github-org "nacoolplayz-org1" --github-repo "ado_to_github_mig_GEI-ado_to_github_mig_GEI" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-ado_to_github_mig_GEI"] = $MigrationID

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ado_to_github_mig_GEI" --ado-repo "repo_migration_test" --github-org "nacoolplayz-org1" --github-repo "ado_to_github_mig_GEI-repo_migration_test" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-repo_migration_test"] = $MigrationID

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ado_to_github_mig_GEI" --ado-repo "test_repo_creation" --github-org "nacoolplayz-org1" --github-repo "ado_to_github_mig_GEI-test_repo_creation" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo_creation"] = $MigrationID

$MigrationID = ExecAndGetMigrationID { gh ado2gh migrate-repo --ado-org "nacoolplayz" --ado-team-project "ado_to_github_mig_GEI" --ado-repo "test_repo2" --github-org "nacoolplayz-org1" --github-repo "ado_to_github_mig_GEI-test_repo2" --queue-only --target-repo-visibility private }
$RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo2"] = $MigrationID

# =========== Waiting for all migrations to finish for Organization: nacoolplayz ===========

# === Waiting for repo migration to finish for Team Project: ADO_to_GitHub_migration and Repo: ADO_to_GitHub_migration. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-ADO_to_GitHub_migration"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-ADO_to_GitHub_migration"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ADO_to_GitHub_migration and Repo: Demo_repo_1. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_1"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_1"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ADO_to_GitHub_migration and Repo: Demo_repo_2. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_2"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ADO_to_GitHub_migration-Demo_repo_2"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ado_to_github_mig_GEI and Repo: ado_to_github_mig_GEI. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-ado_to_github_mig_GEI"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-ado_to_github_mig_GEI"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ado_to_github_mig_GEI and Repo: repo_migration_test. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-repo_migration_test"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-repo_migration_test"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ado_to_github_mig_GEI and Repo: test_repo_creation. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo_creation"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo_creation"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

# === Waiting for repo migration to finish for Team Project: ado_to_github_mig_GEI and Repo: test_repo2. Will then complete the below post migration steps. ===
$CanExecuteBatch = $false
if ($null -ne $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo2"]) {
    gh ado2gh wait-for-migration --migration-id $RepoMigrations["nacoolplayz/ado_to_github_mig_GEI-test_repo2"]
    $CanExecuteBatch = ($lastexitcode -eq 0)
}
if ($CanExecuteBatch) {
    $Succeeded++
} else {
    $Failed++
}

Write-Host =============== Summary ===============
Write-Host Total number of successful migrations: $Succeeded
Write-Host Total number of failed migrations: $Failed

if ($Failed -ne 0) {
    exit 1
}


