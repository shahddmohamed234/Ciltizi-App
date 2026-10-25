Add-Type -AssemblyName System.Drawing
$imgPath = (Resolve-Path "assets/icon/app_icon.jpg").Path
$outPath = Join-Path (Get-Location) "assets/icon/app_icon.png"
$image = [System.Drawing.Image]::FromFile($imgPath)
$image.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$image.Dispose()
Write-Host "Converted successfully to $outPath"
