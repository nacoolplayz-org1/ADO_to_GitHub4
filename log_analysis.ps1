# Set the root folder containing all migration logs
$logRoot = "C:\Users\bhara\logs"

# Create output file for combined errors and warnings
$errorReport = "$logRoot\CombinedErrors.txt"
$summaryReport = "$logRoot\MigrationSummary.csv"

# Initialize summary list
$summaryList = @()

# Get all migration.log and error.log files
$logFiles = Get-ChildItem -Path $logRoot -Filter "migration.log" -Recurse
$errorFiles = Get-ChildItem -Path $logRoot -Filter "error.log" -Recurse
$csvFiles = Get-ChildItem -Path $logRoot -Filter "repo-migration-summary.csv" -Recurse

Write-Host "`n🔍 Starting log analysis across multiple repos..."

# Analyze migration.log for errors and warnings
foreach ($file in $logFiles) {
    Write-Host "Scanning: $($file.FullName)"
    $matches = Select-String -Path $file.FullName -Pattern "ERROR", "WARNING"
    foreach ($match in $matches) {
        "$($file.Name): Line $($match.LineNumber): $($match.Line)" | Out-File -Append $errorReport
    }
}

# Analyze error.log files
foreach ($file in $errorFiles) {
    Write-Host "Scanning error log: $($file.FullName)"
    $lines = Get-Content $file.FullName
    foreach ($line in $lines) {
        "$($file.Name): $line" | Out-File -Append $errorReport
    }
}

# Summarize repo-migration-summary.csv files
foreach ($csv in $csvFiles) {
    $data = Import-Csv $csv.FullName
    foreach ($row in $data) {
        $summaryList += [PSCustomObject]@{
            Repository = $row.RepositoryName
            Status     = $row.Status
            Message    = $row.Message
        }
    }
}

# Export summary to CSV
$summaryList | Export-Csv -Path $summaryReport -NoTypeInformation

Write-Host "`n✅ Log analysis complete."
Write-Host "📄 Combined error report saved to: $errorReport"
Write-Host "📊 Migration summary saved to: $summaryReport"