Add-Type -AssemblyName System.Drawing

function Resize-Image {
    param (
        [string]$SourcePath,
        [string]$TargetPath,
        [int]$Width,
        [int]$Height
    )
    $srcImage = [System.Drawing.Image]::FromFile($SourcePath)
    $destRect = New-Object System.Drawing.Rectangle(0, 0, $Width, $Height)
    $destImage = New-Object System.Drawing.Bitmap($Width, $Height)
    $destImage.SetResolution($srcImage.HorizontalResolution, $srcImage.VerticalResolution)
    $graphics = [System.Drawing.Graphics]::FromImage($destImage)
    $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
    $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $graphics.DrawImage($srcImage, $destRect, 0, 0, $srcImage.Width, $srcImage.Height, [System.Drawing.GraphicsUnit]::Pixel)
    $graphics.Dispose()
    $srcImage.Dispose()
    
    $parentDir = [System.IO.Path]::GetDirectoryName($TargetPath)
    if (-not (Test-Path $parentDir)) {
        New-Item -ItemType Directory -Force -Path $parentDir | Out-Null
    }
    $destImage.Save($TargetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $destImage.Dispose()
    Write-Host "Created: $TargetPath ($Width x $Height)"
}

$source = (Resolve-Path "assets/icon/app_icon.png").Path

# Android Icons
Resize-Image $source "android/app/src/main/res/mipmap-mdpi/ic_launcher.png" 48 48
Resize-Image $source "android/app/src/main/res/mipmap-hdpi/ic_launcher.png" 72 72
Resize-Image $source "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png" 96 96
Resize-Image $source "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png" 144 144
Resize-Image $source "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" 192 192

# iOS Icons
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png" 20 20
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png" 40 40
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png" 60 60
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png" 29 29
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png" 58 58
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png" 87 87
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png" 40 40
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png" 80 80
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png" 120 120
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png" 120 120
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png" 180 180
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png" 76 76
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png" 152 152
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png" 167 167
Resize-Image $source "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png" 1024 1024

# Web Icons
Resize-Image $source "web/icons/Icon-192.png" 192 192
Resize-Image $source "web/icons/Icon-512.png" 512 512
Resize-Image $source "web/icons/Icon-maskable-192.png" 192 192
Resize-Image $source "web/icons/Icon-maskable-512.png" 512 512
Resize-Image $source "web/favicon.png" 64 64

Write-Host "All launcher icons generated successfully!"
