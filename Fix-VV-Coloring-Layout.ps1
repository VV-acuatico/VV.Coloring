# Fix-VV-Coloring-Layout.ps1
# Скрипт для исправления хаоса с MainLayout в проекте VV.Coloring

Write-Host "=== Fixing VV.Coloring Layout Chaos ===" -ForegroundColor Cyan

# Установка UTF-8 кодировки
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Пути проекта
$ProjectRoot = "C:\Git\VV.Coloring"
$WebAppPath = Join-Path $ProjectRoot "src\frontend\Coloring.WebApp"
$PagesPath = Join-Path $WebAppPath "Pages"
$ComponentsPath = Join-Path $WebAppPath "Components"
$LayoutPath = Join-Path $ComponentsPath "Layout"
$WwwrootPath = Join-Path $WebAppPath "wwwroot"
$CssPath = Join-Path $WwwrootPath "css"

# Создаем резервные копии перед изменениями
Write-Host "`nCreating backups..." -ForegroundColor Green
$BackupDir = Join-Path $ProjectRoot "Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

$FilesToBackup = @(
    (Join-Path $PagesPath "MainLayout.razor"),
    (Join-Path $LayoutPath "MainLayout.razor"),
    (Join-Path $PagesPath "Index.razor"),
    (Join-Path $PagesPath "Episode1.razor"),
    (Join-Path $CssPath "custom.css")
)

foreach ($file in $FilesToBackup) {
    if (Test-Path $file) {
        $backupFile = Join-Path $BackupDir (Split-Path $file -Leaf)
        Copy-Item $file $backupFile -Force
        Write-Host "  Backed up: $(Split-Path $file -Leaf)" -ForegroundColor Gray
    }
}

Write-Host "  Backups saved to: $BackupDir" -ForegroundColor Green

# 1. Определяем, какой MainLayout используется
Write-Host "`n1. Analyzing which MainLayout is used..." -ForegroundColor Yellow

# Проверяем App.razor для определения используемого макета
$AppRazorPath = Join-Path $WebAppPath "App.razor"
if (Test-Path $AppRazorPath) {
    $appContent = Get-Content $AppRazorPath -Raw
    if ($appContent -match 'Layout\s*=\s*typeof\(([^)]+)\)') {
        Write-Host "  Found layout in App.razor: $($matches[1])" -ForegroundColor Cyan
    }
}

# Проверяем _Imports.razor
$ImportsPath = Join-Path $PagesPath "_Imports.razor"
if (Test-Path $ImportsPath) {
    $importsContent = Get-Content $ImportsPath -Raw
    if ($importsContent -match '@layout\s+([^\s]+)') {
        Write-Host "  Found layout in _Imports.razor: $($matches[1])" -ForegroundColor Cyan
    }
}

# 2. Исправляем структуру - оставляем только один MainLayout
Write-Host "`n2. Fixing MainLayout structure..." -ForegroundColor Yellow

# Идея: Используем MainLayout из Components/Layout, а дубликат из Pages удаляем
# Сначала создаем правильный MainLayout в Components/Layout

$CorrectMainLayoutContent = @'
@inherits LayoutComponentBase
@implements IDisposable

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Magical Coloring World - Interactive coloring experience" />
    <base href="~/" />
    
    <!-- CSS -->
    <link rel="stylesheet" href="css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" href="css/site.css" />
    <link rel="stylesheet" href="css/custom.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    
    <HeadContent />
    
    <style>
        /* Inline styles for critical rendering */
        .magical-container {
            background: linear-gradient(135deg, #f3e5f5 0%, #e8f5e9 100%);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
    </style>
</head>
<body class="magical-container">
    <div class="container-fluid p-0">
        <!-- Navigation -->
        <nav class="navbar navbar-expand-lg navbar-light magical-navbar">
            <div class="container">
                <a class="navbar-brand magical-title" href="/">
                    <i class="bi bi-stars me-2"></i>Magical Coloring
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <ul class="navbar-nav ms-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/">
                                <i class="bi bi-house"></i> Home
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/episode1">
                                <i class="bi bi-book"></i> Story
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-palette"></i> Coloring
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="/coloring1">Scene 1</a></li>
                                <li><a class="dropdown-item" href="/coloring2">Scene 2</a></li>
                                <li><a class="dropdown-item" href="/coloring3">Scene 3</a></li>
                                <li><a class="dropdown-item" href="/coloring4">Scene 4</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- Main Content -->
        <main role="main" class="pb-3">
            @Body
        </main>

        <!-- Footer -->
        <footer class="border-top footer text-muted magical-footer">
            <div class="container">
                <div class="row">
                    <div class="col-md-6">
                        <span>&copy; 2024 - Magical Coloring World</span>
                    </div>
                    <div class="col-md-6 text-end">
                        <a href="/privacy" class="text-muted me-3">Privacy</a>
                        <a href="/about" class="text-muted">About</a>
                    </div>
                </div>
            </div>
        </footer>
    </div>

    <!-- Scripts -->
    <script src="_framework/blazor.web.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Magical interactivity
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Magical Coloring World loaded!');
            
            // Add floating animation to magical elements
            const magicalElements = document.querySelectorAll('.magical-element');
            magicalElements.forEach((el, index) => {
                el.style.animationDelay = (index * 0.2) + 's';
                el.classList.add('float-animation');
            });

            // Initialize tooltips
            var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
            var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                return new bootstrap.Tooltip(tooltipTriggerEl)
            });
        });
        
        // Cleanup on page navigation
        document.addEventListener('onunload', function() {
            console.log('Cleaning up magical effects...');
        });
    </script>
    
    @if (IsClient)
    {
        <script>
            // Client-side specific scripts
            console.log('Running in interactive mode');
        </script>
    }
</body>
</html>

@code {
    [CascadingParameter]
    private HttpContext? HttpContext { get; set; }
    
    private bool IsClient => HttpContext == null;
    
    public void Dispose()
    {
        // Cleanup if needed
    }
}
'@

# Сохраняем правильный MainLayout в Components/Layout
$CorrectMainLayoutPath = Join-Path $LayoutPath "MainLayout.razor"
try {
    $CorrectMainLayoutContent | Out-File -FilePath $CorrectMainLayoutPath -Encoding UTF8 -Force
    Write-Host "  Created/updated MainLayout in Components/Layout/" -ForegroundColor Green
}
catch {
    Write-Host "  Error updating MainLayout: $_" -ForegroundColor Red
}

# 3. Удаляем дубликат из Pages (если существует)
$PagesMainLayoutPath = Join-Path $PagesPath "MainLayout.razor"
if (Test-Path $PagesMainLayoutPath) {
    try {
        Remove-Item $PagesMainLayoutPath -Force
        Write-Host "  Removed duplicate MainLayout from Pages/" -ForegroundColor Green
    }
    catch {
        Write-Host "  Warning: Could not remove Pages/MainLayout.razor: $_" -ForegroundColor Yellow
    }
}

# 4. Обновляем _Imports.razor чтобы использовать правильный макет
Write-Host "`n3. Updating _Imports.razor..." -ForegroundColor Yellow

$ImportsContent = @'
@using System.Net.Http
@using Microsoft.AspNetCore.Components.Forms
@using Microsoft.AspNetCore.Components.Routing
@using Microsoft.AspNetCore.Components.Web
@using Microsoft.AspNetCore.Components.Web.Virtualization
@using Microsoft.JSInterop
@using Coloring.WebApp
@using Coloring.WebApp.Shared
@using Coloring.WebApp.Components.Layout

@layout MainLayout
'@

try {
    $ImportsContent | Out-File -FilePath $ImportsPath -Encoding UTF8 -Force
    Write-Host "  Updated _Imports.razor" -ForegroundColor Green
}
catch {
    Write-Host "  Error updating _Imports.razor: $_" -ForegroundColor Red
}

# 5. Обновляем остальные файлы для совместимости
Write-Host "`n4. Updating other pages for compatibility..." -ForegroundColor Yellow

# 5.1. Обновляем Index.razor
$IndexPath = Join-Path $PagesPath "Index.razor"
$IndexContent = @'
@page "/"

<PageTitle>Magical Coloring World</PageTitle>

<div class="container py-5">
    <div class="text-center mb-5">
        <h1 class="magical-title display-4 mb-4">
            <i class="bi bi-stars"></i> Welcome to Magical Coloring World
        </h1>
        
        <div class="magical-text lead mb-4">
            <p class="mb-3">Embark on an enchanted journey through magical realms. Each scene tells a story waiting for your colors!</p>
            <p>Choose an episode below to begin your adventure.</p>
        </div>

        <div class="d-flex justify-content-center gap-3 mb-5">
            <a href="/episode1" class="btn magical-btn btn-lg">
                <i class="bi bi-play-circle me-2"></i> Start Journey
            </a>
            <a href="/coloring1" class="btn magical-btn btn-lg">
                <i class="bi bi-palette me-2"></i> Quick Coloring
            </a>
        </div>
    </div>

    <div class="row g-4 mb-5">
        <div class="col-md-4">
            <div class="magical-card h-100 text-center p-4">
                <i class="bi bi-magic display-4 mb-3" style="color: var(--magical-primary);"></i>
                <h3 class="mb-3">Interactive Stories</h3>
                <p>Follow magical tales with interactive elements that respond to your colors.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="magical-card h-100 text-center p-4">
                <i class="bi bi-palette2 display-4 mb-3" style="color: var(--magical-secondary);"></i>
                <h3 class="mb-3">Creative Freedom</h3>
                <p>Unleash your creativity with our magical color palette and effects.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="magical-card h-100 text-center p-4">
                <i class="bi bi-tree display-4 mb-3" style="color: var(--magical-accent);"></i>
                <h3 class="mb-3">Enchanted Scenes</h3>
                <p>Explore magical forests, castles, and mythical creatures in every episode.</p>
            </div>
        </div>
    </div>

    <div class="magical-card p-4 mb-5">
        <h2 class="text-center mb-4"><i class="bi bi-gem me-2"></i> Color Palette</h2>
        <div class="color-palette justify-content-center">
            <div class="color-swatch" style="background-color: #9c27b0;" title="Magic Purple" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #e91e63;" title="Fairy Pink" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #00bcd4;" title="Mermaid Blue" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #4caf50;" title="Forest Green" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #ff9800;" title="Sunset Orange" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #ffeb3b;" title="Star Yellow" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #795548;" title="Earth Brown" data-bs-toggle="tooltip"></div>
            <div class="color-swatch" style="background-color: #607d8b;" title="Mystic Gray" data-bs-toggle="tooltip"></div>
        </div>
    </div>
</div>
'@

try {
    $IndexContent | Out-File -FilePath $IndexPath -Encoding UTF8 -Force
    Write-Host "  Updated Index.razor" -ForegroundColor Green
}
catch {
    Write-Host "  Error updating Index.razor: $_" -ForegroundColor Red
}

# 6. Обновляем custom.css для навбара и футера
Write-Host "`n5. Updating custom.css..." -ForegroundColor Yellow

$CustomCssAddition = @'

/* Navbar styles */
.magical-navbar {
    background: linear-gradient(90deg, var(--magical-primary), var(--magical-secondary));
    box-shadow: 0 4px 20px var(--magical-shadow);
    padding: 1rem 0;
}

.magical-navbar .navbar-brand {
    color: white !important;
    font-size: 1.8rem;
    font-weight: bold;
    text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
}

.magical-navbar .nav-link {
    color: rgba(255,255,255,0.9) !important;
    font-weight: 500;
    margin: 0 5px;
    padding: 8px 15px !important;
    border-radius: 20px;
    transition: all 0.3s ease;
}

.magical-navbar .nav-link:hover {
    color: white !important;
    background: rgba(255,255,255,0.2);
    transform: translateY(-2px);
}

.magical-navbar .dropdown-menu {
    background: white;
    border: 2px solid var(--magical-border);
    border-radius: 10px;
    box-shadow: 0 10px 30px var(--magical-shadow);
}

.magical-navbar .dropdown-item {
    color: var(--magical-text);
    padding: 10px 20px;
    transition: all 0.3s ease;
}

.magical-navbar .dropdown-item:hover {
    background: rgba(156, 39, 176, 0.1);
    color: var(--magical-primary);
}

/* Footer styles */
.magical-footer {
    background: linear-gradient(90deg, var(--magical-primary), var(--magical-secondary));
    color: white !important;
    padding: 2rem 0 !important;
    margin-top: 3rem;
}

.magical-footer a {
    color: rgba(255,255,255,0.9) !important;
    text-decoration: none;
    transition: color 0.3s ease;
}

.magical-footer a:hover {
    color: white !important;
    text-decoration: underline;
}

/* Main content area */
main {
    min-height: calc(100vh - 200px);
    padding: 2rem 0;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .magical-navbar .navbar-brand {
        font-size: 1.4rem;
    }
    
    .magical-navbar .nav-link {
        padding: 6px 10px !important;
        margin: 2px 0;
    }
    
    .magical-title {
        font-size: 2rem !important;
    }
    
    .magical-btn {
        padding: 10px 20px !important;
        font-size: 1rem !important;
    }
}
'@

# Читаем существующий custom.css и добавляем новые стили
$CustomCssPath = Join-Path $CssPath "custom.css"
if (Test-Path $CustomCssPath) {
    try {
        $existingCss = Get-Content $CustomCssPath -Raw
        $newCss = $existingCss + $CustomCssAddition
        $newCss | Out-File -FilePath $CustomCssPath -Encoding UTF8 -Force
        Write-Host "  Updated custom.css with navbar/footer styles" -ForegroundColor Green
    }
    catch {
        Write-Host "  Error updating custom.css: $_" -ForegroundColor Red
    }
}
else {
    Write-Host "  Warning: custom.css not found" -ForegroundColor Yellow
}

# 7. Проверяем наличие необходимых файлов
Write-Host "`n6. Verifying required files..." -ForegroundColor Yellow

$RequiredFiles = @(
    @{Path=$CorrectMainLayoutPath; Name="MainLayout.razor (correct)"},
    @{Path=$ImportsPath; Name="_Imports.razor"},
    @{Path=$IndexPath; Name="Index.razor"},
    @{Path=$CustomCssPath; Name="custom.css"}
)

foreach ($file in $RequiredFiles) {
    if (Test-Path $file.Path) {
        $size = (Get-Item $file.Path).Length
        Write-Host "  ✓ $($file.Name) exists ($size bytes)" -ForegroundColor Green
    }
    else {
        Write-Host "  ✗ $($file.Name) is missing" -ForegroundColor Red
    }
}

# 8. Проверяем, что Pages/MainLayout.razor удалён
if (Test-Path $PagesMainLayoutPath) {
    Write-Host "  Warning: Pages/MainLayout.razor still exists (should be removed)" -ForegroundColor Yellow
}
else {
    Write-Host "  ✓ Pages/MainLayout.razor has been removed" -ForegroundColor Green
}

Write-Host "`n=== Fix Complete! ===" -ForegroundColor Cyan
Write-Host "`nSummary of changes:" -ForegroundColor Yellow
Write-Host "1. Created/updated MainLayout.razor in Components/Layout/" -ForegroundColor White
Write-Host "2. Removed duplicate MainLayout.razor from Pages/" -ForegroundColor White
Write-Host "3. Updated _Imports.razor to use the correct layout" -ForegroundColor White
Write-Host "4. Updated Index.razor for compatibility" -ForegroundColor White
Write-Host "5. Added navbar/footer styles to custom.css" -ForegroundColor White
Write-Host "`nBackup location: $BackupDir" -ForegroundColor Gray

Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Build the project: dotnet build" -ForegroundColor White
Write-Host "2. Run the project: dotnet run" -ForegroundColor White
Write-Host "3. Visit http://localhost:5000 to verify the fix" -ForegroundColor White
Write-Host "`nIf there are issues, restore files from: $BackupDir" -ForegroundColor Gray

# Сохраняем скрипт с правильной кодировкой
$ScriptContent = Get-Content -Path $MyInvocation.MyCommand.Path -Raw
$ScriptContent | Out-File -FilePath $MyInvocation.MyCommand.Path -Encoding UTF8 -Force
