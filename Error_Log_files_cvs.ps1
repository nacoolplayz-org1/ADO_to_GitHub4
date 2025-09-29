# Define the folder containing log files
$logFolder = "C:\Users\bhara\logs"
$outputCsv = "$logFolder\error_files_report.csv"

# Create an empty array to store matching filenames
$errorFiles = @()

# Get all .log files in the folder
$logFiles = Get-ChildItem -Path $logFolder -Filter *.log

# Process each log file
foreach ($file in $logFiles) {
    $lines = Get-Content $file.FullName
    foreach ($line in $lines) {
        if ($line -match "ERROR") {
            $errorFiles += [PSCustomObject]@{
                FileName = $file.Name
            }
            break  # Stop checking further lines in this file
        }
    }
}

# Export matching filenames to CSV
$errorFiles | Export-Csv -Path $outputCsv -NoTypeInformation -Encoding UTF8

Write-Host "✅ Report saved to: $outputCsv"
