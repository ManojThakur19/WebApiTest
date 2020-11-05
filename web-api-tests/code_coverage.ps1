    Write-Host "Code Coverage Report Generation Started." -ForegroundColor Green

    $currentDirectory = Get-Location
    $testProjectPath = "$currentDirectory\web-api-tests"
    $testSettingsPath = "$currentDirectory\web-api-tests\codecoverage.runsettings"

try {

    Write-Host "Cache clean up running..." -ForegroundColor Green
    $testResultDirectory = "$currentDirectory\TestResults"
    if ((Test-Path -Path $testResultDirectory -PathType Container)) 
    {
       Remove-Item -path $testResultDirectory -recurse 
    }
    Write-Host "Cache clean up successful" -ForegroundColor Green 


    Write-Host "dotnet test running..." -ForegroundColor Green
    dotnet test $testProjectPath --settings:$testSettingsPath 
    $recentCoverageFile = Get-ChildItem -File -Filter *.coverage -Path $testResultDirectory -Name -Recurse | Select-Object -First 1;
    write-host 'test successful'  -ForegroundColor Green


    Write-Host "converting coverage file to coverageXml..." -ForegroundColor Green
    C:\Users\i157864\.nuget\packages\microsoft.codecoverage\16.7.1\build\netstandard1.0\CodeCoverage\CodeCoverage.exe analyze  /output:$testResultDirectory\MyTestOutput.coveragexml  $testResultDirectory'\'$recentCoverageFile
    write-host 'CoverageXML Generated'  -ForegroundColor Green


    Write-Host "converting Html report from CoverageXML..." -ForegroundColor Green
    dotnet C:\Users\i157864\.nuget\packages\reportgenerator\4.7.1\tools\netcoreapp2.1\ReportGenerator.dll "-reports:$testResultDirectory\MyTestOutput.coveragexml" "-targetdir:$testResultDirectory\coveragereport"
    write-host 'CoverageReport Published'  -ForegroundColor Green
    
}
catch {

    write-host "Caught an exception:" -ForegroundColor Red
}