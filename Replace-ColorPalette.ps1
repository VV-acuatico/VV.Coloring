# Replace-ColorPalette.ps1
# Ð¡ÐºÑ€Ð¸Ð¿Ñ‚ Ð·Ð°Ð¼ÐµÐ½Ñ‹ Ñ†Ð²ÐµÑ‚Ð¾Ð²Ð¾Ð¹ Ð¿Ð°Ð»Ð¸Ñ‚Ñ€Ñ‹ Ð² Ð¿Ñ€Ð¾ÐµÐºÑ‚Ðµ VV.Coloring

Write-Host "=== Replacing Color Palette in VV.Coloring ===" -ForegroundColor Cyan

# Ð£ÑÑ‚Ð°Ð½Ð¾Ð²ÐºÐ° UTF-8 ÐºÐ¾Ð´Ð¸Ñ€Ð¾Ð²ÐºÐ¸
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ÐŸÑƒÑ‚Ð¸ Ð¿Ñ€Ð¾ÐµÐºÑ‚Ð°
$ProjectRoot = "C:\Git\VV.Coloring"
$WebAppPath = Join-Path $ProjectRoot "src\frontend\Coloring.WebApp"
$PagesPath = Join-Path $WebAppPath "Pages"
$ComponentsPath = Join-Path $WebAppPath "Components"
$LayoutPath = Join-Path $ComponentsPath "Layout"
$WwwrootPath = Join-Path $WebAppPath "wwwroot"
$CssPath = Join-Path $WwwrootPath "css"

# ÐÐ¾Ð²Ð°Ñ Ñ†Ð²ÐµÑ‚Ð¾Ð²Ð°Ñ Ð¿Ð°Ð»Ð¸Ñ‚Ñ€Ð° (Ð¾ÑÐ½Ð¾Ð²Ð½Ñ‹Ðµ Ñ†Ð²ÐµÑ‚Ð° Ð¸Ð· Ð³Ð°Ð¼Ð¼Ñ‹)
$newColors = @{
    "orange"     = "#FF9700"  # Ð¯Ñ€ÐºÐ¸Ð¹ Ð¾Ñ€Ð°Ð½Ð¶ÐµÐ²Ñ‹Ð¹
    "green"      = "#3CC376"  # Ð—ÐµÐ»ÐµÐ½Ñ‹Ð¹
    "gold"       = "#FDC862"  # Ð¡Ð²ÐµÑ‚Ð»Ñ‹Ð¹ Ð·Ð¾Ð»Ð¾Ñ‚Ð¸ÑÑ‚Ñ‹Ð¹
    "olive"      = "#906700"  # Ð¢ÐµÐ¼Ð½Ñ‹Ð¹ Ð¾Ð»Ð¸Ð²ÐºÐ¾Ð²Ñ‹Ð¹
    "darkbrown"  = "#532B11"  # ÐžÑ‡ÐµÐ½ÑŒ Ñ‚ÐµÐ¼Ð½Ñ‹Ð¹ ÐºÐ¾Ñ€Ð¸Ñ‡Ð½ÐµÐ²Ñ‹Ð¹
    "brown"      = "#916631"  # ÐšÐ¾Ñ€Ð¸Ñ‡Ð½ÐµÐ²Ñ‹Ð¹
    "teal"       = "#29916B"  # Ð—ÐµÐ»ÐµÐ½Ñ‹Ð¹ Ð¼Ð¾Ñ€ÑÐºÐ¾Ð¹ Ð²Ð¾Ð»Ð½Ñ‹
    "darkolive"  = "#644402"  # Ð¢ÐµÐ¼Ð½Ñ‹Ð¹ ÐºÐ¾Ñ€Ð¸Ñ‡Ð½ÐµÐ²Ñ‹Ð¹
    
    # ÐŸÑ€Ð¾Ð¸Ð·Ð²Ð¾Ð´Ð½Ñ‹Ðµ Ð´Ð»Ñ Ð»ÑƒÑ‡ÑˆÐµÐ¹ Ñ‡Ð¸Ñ‚Ð°ÐµÐ¼Ð¾ÑÑ‚Ð¸
    "lightbg"    = "#FFF9F0"  # Ð¡Ð²ÐµÑ‚Ð»Ñ‹Ð¹ Ñ„Ð¾Ð½
    "cardbg"     = "#FFFFFF"  # Ð¤Ð¾Ð½ ÐºÐ°Ñ€Ñ‚Ð¾Ñ‡ÐµÐº
    "hover"      = "#E68600"  # Ð¥Ð¾Ð²ÐµÑ€ Ð¾Ñ€Ð°Ð½Ð¶ÐµÐ²Ñ‹Ð¹
    "hovergreen" = "#34AD68"  # Ð¥Ð¾Ð²ÐµÑ€ Ð·ÐµÐ»ÐµÐ½Ñ‹Ð¹
    "textlight"  = "#FFFFFF"  # Ð‘ÐµÐ»Ñ‹Ð¹ Ñ‚ÐµÐºÑÑ‚
}

# Ð¡Ð¾Ð·Ð´Ð°ÐµÐ¼ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½ÑƒÑŽ ÐºÐ¾Ð¿Ð¸ÑŽ
$BackupDir = Join-Path $ProjectRoot "Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')_Colors"
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null
Write-Host "Backup directory: $BackupDir" -ForegroundColor Gray

# 1. ÐžÐ±Ð½Ð¾Ð²Ð»ÑÐµÐ¼ custom.css
Write-Host "`n1. Updating custom.css..." -ForegroundColor Yellow

$CustomCssPath = Join-Path $CssPath "custom.css"
if (Test-Path $CustomCssPath) {
    # Ð¡Ð¾Ð·Ð´Ð°ÐµÐ¼ Ñ€ÐµÐ·ÐµÑ€Ð²Ð½ÑƒÑŽ ÐºÐ¾Ð¿Ð¸ÑŽ
    Copy-Item $CustomCssPath (Join-Path $BackupDir "custom.css") -Force
    
    $cssContent = Get-Content $CustomCssPath -Raw
    
    # Ð—Ð°Ð¼ÐµÐ½ÑÐµÐ¼ Ñ†Ð²ÐµÑ‚Ð° Ð² CSS
    $newCssContent = $cssContent -replace '#9c27b0', $newColors.orange `
                                 -replace '#e91e63', $newColors.green `
                                 -replace '#00bcd4', $newColors.gold `
                                 -replace '#f3e5f5', $newColors.lightbg `
                                 -replace '#e8f5e9', "#F5F9F3" `
                                 -replace '#4a148c', $newColors.darkbrown `
                                 -replace '#d1c4e9', $newColors.brown `
                                 -replace 'rgba\(156, 39, 176', "rgba(255, 151, 0" `
                                 -replace 'var\(--magical-primary\)', $newColors.orange `
                                 -replace 'var\(--magical-secondary\)', $newColors.green `
                                 -replace 'var\(--magical-accent\)', $newColors.gold `
                                 -replace '--magical-text:', "--magical-text: $($newColors.darkbrown);" `
                                 -replace '--magical-background:', "--magical-background: $($newColors.lightbg);"
    
    $newCssContent | Out-File -FilePath $CustomCssPath -Encoding UTF8 -Force
    Write-Host "  Updated custom.css" -ForegroundColor Green
}
else {
    Write-Host "  Warning: custom.css not found" -ForegroundColor Yellow
}

# 2. ÐžÐ±Ð½Ð¾Ð²Ð»ÑÐµÐ¼ Index.razor (Ñ†Ð²ÐµÑ‚Ð¾Ð²Ñ‹Ðµ swatches)
Write-Host "`n2. Updating Index.razor..." -ForegroundColor Yellow

$IndexPath = Join-Path $PagesPath "Index.razor"
if (Test-Path $IndexPath) {
    Copy-Item $IndexPath (Join-Path $BackupDir "Index.razor") -Force
    
    $content = Get-Content $IndexPath -Raw
    
    # Ð—Ð°Ð¼ÐµÐ½ÑÐµÐ¼ Ñ†Ð²ÐµÑ‚Ð¾Ð²Ñ‹Ðµ swatches
    $newContent = $content -replace '#9c27b0', $newColors.orange `
                           -replace '#e91e63', $newColors.green `
                           -replace '#00bcd4', $newColors.gold `
                           -replace '#4caf50', $newColors.teal `
                           -replace '#ff9800', $newColors.olive `
                           -replace '#ffeb3b', $newColors.brown `
                           -replace '#795548', $newColors.darkolive `
                           -replace '#607d8b', $newColors.darkbrown `
                           -replace 'Magic Purple', 'Orange' `
                           -replace 'Fairy Pink', 'Green' `
                           -replace 'Mermaid Blue', 'Gold' `
                           -replace 'Forest Green', 'Teal' `
                           -replace 'Sunset Orange', 'Olive' `
                           -replace 'Star Yellow', 'Brown' `
                           -replace 'Earth Brown', 'Dark Olive' `
                           -replace 'Mystic Gray', 'Dark Brown'
    
    $newContent | Out-File -FilePath $IndexPath -Encoding UTF8 -Force
    Write-Host "  Updated Index.razor color swatches" -ForegroundColor Green
}

# 3. ÐžÐ±Ð½Ð¾Ð²Ð»ÑÐµÐ¼ Ð´Ñ€ÑƒÐ³Ð¸Ðµ ÑÑ‚Ñ€Ð°Ð½Ð¸Ñ†Ñ‹ Ñ Ñ†Ð²ÐµÑ‚Ð°Ð¼Ð¸
Write-Host "`n3. Updating other pages..." -ForegroundColor Yellow

$pages = @(
    "Episode1.razor",
    "Scene1.razor",
    "Scene2.razor", 
    "Scene3.razor",
    "Scene4.razor",
    "Coloring1.razor",
    "Coloring2.razor",
    "Coloring3.razor",
    "Coloring4.razor"
)

foreach ($page in $pages) {
    $pagePath = Join-Path $PagesPath $page
    if (Test-Path $pagePath) {
        try {
            $content = Get-Content $pagePath -Raw
            
            # ÐŸÑ€Ð¾ÑÑ‚Ñ‹Ðµ Ð·Ð°Ð¼ÐµÐ½Ñ‹ Ñ†Ð²ÐµÑ‚Ð¾Ð²
            $newContent = $content -replace '#9c27b0', $newColors.orange `
                                   -replace '#e91e63', $newColors.green `
                                   -replace '#00bcd4', $newColors.gold `
                                   -replace '#4caf50', $newColors.teal `
                                   -replace '#ff9800', $newColors.olive `
                                   -replace '#ffeb3b', $newColors.brown `
                                   -replace '#795548', $newColors.darkolive `
                                   -replace '#607d8b', $newColors.darkbrown `
                                   -replace 'var\(--magical-primary\)', $newColors.orange
            
            $newContent | Out-File -FilePath $pagePath -Encoding UTF8 -Force
            Write-Host "  Updated $page" -ForegroundColor Green
        }
        catch {
            Write-Host "  Error updating $page : $_" -ForegroundColor Red
        }
    }
}

# 4. ÐŸÑ€Ð¾Ð²ÐµÑ€ÑÐµÐ¼ Ð¸ Ð¾Ð±Ð½Ð¾Ð²Ð»ÑÐµÐ¼ MainLayout.razor
Write-Host "`n4. Checking MainLayout.razor..." -ForegroundColor Yellow

$MainLayoutPath = Join-Path $LayoutPath "MainLayout.razor"
if (Test-Path $MainLayoutPath) {
    Copy-Item $MainLayoutPath (Join-Path $BackupDir "MainLayout.razor") -Force
    
    $content = Get-Content $MainLayoutPath -Raw
    
    # ÐžÐ±Ð½Ð¾Ð²Ð»ÑÐµÐ¼ Ð³Ñ€Ð°Ð´Ð¸ÐµÐ½Ñ‚Ñ‹ Ð² Ð½Ð°Ð²Ð±Ð°Ñ€Ðµ Ð¸ Ñ„ÑƒÑ‚ÐµÑ€Ðµ
    $newContent = $content -replace '#9c27b0', $newColors.orange `
                           -replace '#e91e63', $newColors.green `
                           -replace 'rgba\(156, 39, 176', "rgba(255, 151, 0" `
                           -replace 'linear-gradient\(90deg, #9c27b0', "linear-gradient(90deg, $($newColors.orange)" `
                           -replace 'linear-gradient\(90deg, #e91e63', "linear-gradient(90deg, $($newColors.green)" `
                           -replace '#644402', $newColors.darkolive `
                           -replace '#906700', $newColors.olive
    
    $newContent | Out-File -FilePath $MainLayoutPath -Encoding UTF8 -Force
    Write-Host "  Updated MainLayout.razor" -ForegroundColor Green
}

# 5. Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ Ð½ÐµÐ´Ð¾ÑÑ‚Ð°ÑŽÑ‰Ð¸Ðµ ÑÑ‚Ð¸Ð»Ð¸ Ð´Ð»Ñ Ð½Ð¾Ð²Ð¾Ð¹ Ð¿Ð°Ð»Ð¸Ñ‚Ñ€Ñ‹
Write-Host "`n5. Adding missing styles to custom.css..." -ForegroundColor Yellow

$AdditionalStyles = @"

/* Additional styles for new color palette */
.magical-navbar {
    background: linear-gradient(90deg, $($newColors.orange) 0%, $($newColors.hover) 100%);
}

.magical-footer {
    background: linear-gradient(90deg, $($newColors.darkolive) 0%, $($newColors.olive) 100%);
}

/* Ð¦Ð²ÐµÑ‚Ð¾Ð²Ñ‹Ðµ ÐºÐ»Ð°ÑÑÑ‹ Ð´Ð»Ñ Ð½Ð¾Ð²Ð¾Ð¹ Ð¿Ð°Ð»Ð¸Ñ‚Ñ€Ñ‹ */
.bg-orange { background-color: $($newColors.orange) !important; }
.bg-green { background-color: $($newColors.green) !important; }
.bg-gold { background-color: $($newColors.gold) !important; }
.bg-olive { background-color: $($newColors.olive) !important; }

.text-orange { color: $($newColors.orange) !important; }
.text-green { color: $($newColors.green) !important; }
.text-gold { color: $($newColors.gold) !important; }
.text-olive { color: $($newColors.olive) !important; }
.text-darkbrown { color: $($newColors.darkbrown) !important; }

/* ÐšÐ½Ð¾Ð¿ÐºÐ¸ Ñ Ð½Ð¾Ð²Ð¾Ð¹ Ð¿Ð°Ð»Ð¸Ñ‚Ñ€Ð¾Ð¹ */
.btn-orange {
    background-color: $($newColors.orange);
    color: white;
    border-color: $($newColors.orange);
}

.btn-orange:hover {
    background-color: $($newColors.hover);
    border-color: $($newColors.hover);
}

.btn-green {
    background-color: $($newColors.green);
    color: white;
    border-color: $($newColors.green);
}

.btn-green:hover {
    background-color: $($newColors.hovergreen);
    border-color: $($newColors.hovergreen);
}

/* ÐšÐ¾Ð½Ñ‚Ñ€Ð°ÑÑ‚Ð½Ñ‹Ðµ ÐºÐ¾Ð¼Ð±Ð¸Ð½Ð°Ñ†Ð¸Ð¸ Ð´Ð»Ñ Ð´Ð¾ÑÑ‚ÑƒÐ¿Ð½Ð¾ÑÑ‚Ð¸ */
.high-contrast {
    color: $($newColors.darkbrown);
    background-color: $($newColors.lightbg);
    border: 2px solid $($newColors.darkbrown);
}

.readable-text {
    color: $($newColors.darkbrown);
    font-weight: 600;
    text-shadow: 1px 1px 2px rgba(255,255,255,0.8);
}
"@

# Ð”Ð¾Ð±Ð°Ð²Ð»ÑÐµÐ¼ ÑÑ‚Ð¸Ð»Ð¸ Ð² custom.css
if (Test-Path $CustomCssPath) {
    $currentCss = Get-Content $CustomCssPath -Raw
    $updatedCss = $currentCss + $AdditionalStyles
    $updatedCss | Out-File -FilePath $CustomCssPath -Encoding UTF8 -Force
    Write-Host "  Added additional styles to custom.css" -ForegroundColor Green
}

Write-Host "`n=== Color Palette Replacement Complete! ===" -ForegroundColor Cyan

Write-Host "`nSummary:" -ForegroundColor Yellow
Write-Host "- Primary color: $($newColors.orange) (Orange)" -ForegroundColor $newColors.orange
Write-Host "- Secondary color: $($newColors.green) (Green)" -ForegroundColor Green
Write-Host "- Accent color: $($newColors.gold) (Gold)" -ForegroundColor Yellow
Write-Host "- Text color: $($newColors.darkbrown) (Dark Brown)" -ForegroundColor White
Write-Host "- Background: $($newColors.lightbg) (Light Beige)" -ForegroundColor White

Write-Host "`nBackup saved to: $BackupDir" -ForegroundColor Gray

Write-Host "`nTo test changes:" -ForegroundColor Green
Write-Host "cd '$WebAppPath'" -ForegroundColor White
Write-Host "dotnet build" -ForegroundColor White
Write-Host "dotnet run" -ForegroundColor White

Write-Host "`nNew color scheme features:" -ForegroundColor Yellow
Write-Host "âœ“ High contrast for readability" -ForegroundColor White
Write-Host "âœ“ No red-blue combinations" -ForegroundColor White
Write-Host "âœ“ Warm, earthy colors" -ForegroundColor White
Write-Host "âœ“ Accessible color combinations" -ForegroundColor White
