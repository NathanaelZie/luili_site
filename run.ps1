$dartSdk = "C:\Users\HP\AppData\Local\Microsoft\WinGet\Packages\Google.DartSDK_Microsoft.Winget.Source_8wekyb3d8bbwe\dart-sdk\bin"
$cleanedPath = ($env:PATH -split ';' | Where-Object { $_ -and $_ -notlike '*flutter\bin*' }) -join ';'
$env:PATH = "$dartSdk;$cleanedPath"

Write-Host "Dart SDK version: $(dart --version)"
dart pub global run jaspr_cli:jaspr serve $args

