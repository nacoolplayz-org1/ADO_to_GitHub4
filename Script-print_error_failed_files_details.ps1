# Define the folder containing log files
$logFolder = "C:\Users\bhara\logs"
$outputCsv = "$logFolder\error_failed_report1.csv"

# Create an empty array to store results
$results = @()

# Get all .log files in the folder
$logFiles = Get-ChildItem -Path $logFolder -Filter *.log

# Process each log file
foreach ($file in $logFiles) {
    $hasMatch = $false
    $lines = Get-Content $file.FullName
    foreach ($line in $lines) {
        if ($line -match "ERROR") {
            $hasMatch = $true
            $results += [PSCustomObject]@{
                Message = $line
            }
        }
    }
    if ($hasMatch) {
        Write-Host "⚠️ Found ERROR or FAILED in: $($file.Name)"
    }
}

# Export results to CSV
$results | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "✅ Final report saved to: $outputCsv"