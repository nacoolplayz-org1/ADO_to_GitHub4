# Define the folder containing log files
$logFolder = "C:\Users\bhara\logs"

# Get all .log files in the folder
$logFiles = Get-ChildItem -Path $logFolder -Filter *.log

# Process each log file
foreach ($file in $logFiles) {
    $lines = Get-Content $file.FullName
    foreach ($line in $lines) {
        if ($line -match "ERROR") {
            Write-Host "❗ ERROR found in: $($file.Name)"
            break  # Stop checking further lines in this file
        }
    }
}