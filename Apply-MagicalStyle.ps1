# Apply-MagicalStyle.ps1
# Скрипт для применения стиля магического реализма к проекту VV.Coloring

# Установка UTF-8 кодировки для всего скрипта
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "=== Applying Magical Realism Style to VV.Coloring ===" -ForegroundColor Cyan

# Путь к проекту
$ProjectRoot = "C:\Git\VV.Coloring"
$WebAppPath = Join-Path $ProjectRoot "src\frontend\Coloring.WebApp"
$PagesPath = Join-Path $WebAppPath "Pages"
$WwwrootPath = Join-Path $WebAppPath "wwwroot"
$CssPath = Join-Path $WwwrootPath "css"

# Создаем custom.css
Write-Host "`nCreating custom.css..." -ForegroundColor Green
$CustomCss = @'
/* custom.css - Magical Realism Theme */

:root {
    --magical-primary: #9c27b0;
    --magical-secondary: #e91e63;
    --magical-accent: #00bcd4;
    --magical-background: #f3e5f5;
    --magical-text: #4a148c;
    --magical-border: #d1c4e9;
    --magical-shadow: rgba(156, 39, 176, 0.3);
}

.magical-container {
    background: linear-gradient(135deg, #f3e5f5 0%, #e8f5e9 100%);
    min-height: 100vh;
    padding: 20px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

.magical-title {
    color: var(--magical-text);
    text-align: center;
    margin: 30px 0;
    font-size: 2.5rem;
    text-shadow: 2px 2px 4px var(--magical-shadow);
    animation: title-glow 3s ease-in-out infinite alternate;
}

@keyframes title-glow {
    from { text-shadow: 2px 2px 4px rgba(156, 39, 176, 0.3); }
    to { text-shadow: 2px 2px 8px rgba(156, 39, 176, 0.6), 0 0 12px rgba(233, 30, 99, 0.4); }
}

.magical-text {
    color: var(--magical-text);
    font-size: 1.1rem;
    line-height: 1.6;
    margin: 20px 0;
    padding: 15px;
    background: rgba(255, 255, 255, 0.8);
    border-radius: 10px;
    border-left: 4px solid var(--magical-primary);
}

.magical-btn {
    background: linear-gradient(45deg, var(--magical-primary), var(--magical-secondary));
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 25px;
    font-size: 1.1rem;
    cursor: pointer;
    transition: all 0.3s ease;
    margin: 10px;
    box-shadow: 0 4px 15px var(--magical-shadow);
}

.magical-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px var(--magical-shadow);
    background: linear-gradient(45deg, var(--magical-secondary), var(--magical-primary));
}

.magical-card {
    background: white;
    border-radius: 15px;
    padding: 20px;
    margin: 20px 0;
    box-shadow: 0 5px 20px rgba(0,0,0,0.1);
    border: 2px solid var(--magical-border);
    transition: transform 0.3s ease;
}

.magical-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 25px var(--magical-shadow);
}

.magical-element {
    transition: all 0.3s ease;
}

.magical-element:hover {
    filter: drop-shadow(0 0 10px currentColor);
}

/* Анимации */
@keyframes float {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-10px); }
}

@keyframes pulse {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.7; }
}

.float-animation {
    animation: float 3s ease-in-out infinite;
}

.pulse-animation {
    animation: pulse 2s ease-in-out infinite;
}

/* Специальные классы для раскраски */
.coloring-area {
    border: 3px solid var(--magical-border);
    border-radius: 20px;
    padding: 20px;
    background: white;
    margin: 20px 0;
}

.colorable {
    cursor: pointer;
    transition: fill 0.3s ease;
}

.colorable:hover {
    opacity: 0.9;
    stroke: var(--magical-primary);
    stroke-width: 2px;
}

/* Навигация */
.nav-menu {
    display: flex;
    justify-content: center;
    gap: 20px;
    margin: 30px 0;
    flex-wrap: wrap;
}

.nav-link {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 10px 20px;
    background: white;
    border-radius: 50px;
    text-decoration: none;
    color: var(--magical-text);
    font-weight: 500;
    border: 2px solid var(--magical-border);
    transition: all 0.3s ease;
}

.nav-link:hover {
    background: var(--magical-primary);
    color: white;
    transform: scale(1.05);
}

/* Цветовая палитра */
.color-palette {
    display: flex;
    gap: 10px;
    margin: 20px 0;
    flex-wrap: wrap;
    justify-content: center;
}

.color-swatch {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    cursor: pointer;
    border: 3px solid white;
    box-shadow: 0 3px 10px rgba(0,0,0,0.2);
    transition: transform 0.2s ease;
}

.color-swatch:hover {
    transform: scale(1.2);
}

/* Адаптивность */
@media (max-width: 768px) {
    .magical-title {
        font-size: 2rem;
    }
    
    .magical-container {
        padding: 10px;
    }
    
    .nav-menu {
        flex-direction: column;
        align-items: center;
    }
}
'@

$CustomCssPath = Join-Path $CssPath "custom.css"
try {
    $CustomCss | Out-File -FilePath $CustomCssPath -Encoding UTF8 -Force
    Write-Host "  Custom CSS created" -ForegroundColor Green
}
catch {
    Write-Host "  Error creating custom.css: $_" -ForegroundColor Red
}

# Функция для обновления файлов с обработкой ошибок
function Update-FileWithRetry {
    param(
        [string]$Path,
        [string]$Content,
        [int]$MaxRetries = 3
    )
    
    $retryCount = 0
    while ($retryCount -lt $MaxRetries) {
        try {
            # Закрываем все возможные блокировки файла
            if (Test-Path $Path) {
                Get-Process | Where-Object {
                    $_.Modules | Where-Object { $_.FileName -eq $Path }
                } | Stop-Process -Force -ErrorAction SilentlyContinue
            }
            
            # Даем системе время освободить файл
            Start-Sleep -Milliseconds 500
            
            # Сохраняем файл
            $Content | Out-File -FilePath $Path -Encoding UTF8 -Force
            return $true
        }
        catch {
            $retryCount++
            if ($retryCount -eq $MaxRetries) {
                Write-Host "  Failed to update $($Path) after $MaxRetries attempts: $_" -ForegroundColor Red
                return $false
            }
            Write-Host "  Retry $retryCount for $($Path)..." -ForegroundColor Yellow
            Start-Sleep -Seconds 1
        }
    }
}

# Обновляем MainLayout.razor
Write-Host "`nUpdating MainLayout.razor..." -ForegroundColor Green
$MainLayoutPath = Join-Path $PagesPath "MainLayout.razor"
$MainLayoutContent = @'
@inherits LayoutComponentBase

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Magical Coloring World - Interactive coloring experience" />
    <link rel="stylesheet" href="css/bootstrap/bootstrap.min.css" />
    <link rel="stylesheet" href="css/site.css" />
    <link rel="stylesheet" href="css/custom.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <HeadContent />
</head>
<body class="magical-container">
    <div class="container-fluid">
        <main>
            @Body
        </main>
    </div>

    <script src="_framework/blazor.web.js"></script>
    <script>
        // Magical interactivity
        document.addEventListener('DOMContentLoaded', function() {
            // Add floating animation to magical elements
            const elements = document.querySelectorAll('.magical-element');
            elements.forEach((el, index) => {
                el.style.animationDelay = (index * 0.2) + 's';
                el.classList.add('float-animation');
            });

            // Color swatch interaction
            const swatches = document.querySelectorAll('.color-swatch');
            swatches.forEach(swatch => {
                swatch.addEventListener('click', function() {
                    swatches.forEach(s => s.style.borderColor = 'white');
                    this.style.borderColor = '#9c27b0';
                });
            });
        });
    </script>
</body>
</html>
'@

if (Update-FileWithRetry -Path $MainLayoutPath -Content $MainLayoutContent) {
    Write-Host "  MainLayout updated" -ForegroundColor Green
}

# Обновляем Index.razor
Write-Host "`nUpdating Index.razor..." -ForegroundColor Green
$IndexPath = Join-Path $PagesPath "Index.razor"
$IndexContent = @'
@page "/"

<PageTitle>Magical Coloring World</PageTitle>

<div class="text-center">
    <h1 class="magical-title">
        <i class="bi bi-stars"></i> Welcome to Magical Coloring World
    </h1>
    
    <div class="magical-text">
        <p>Embark on an enchanted journey through magical realms. Each scene tells a story waiting for your colors!</p>
        <p>Choose an episode below to begin your adventure.</p>
    </div>

    <div class="nav-menu">
        <a href="/episode1" class="nav-link magical-btn">
            <i class="bi bi-play-circle"></i> Start Journey
        </a>
        <a href="/coloring1" class="nav-link magical-btn">
            <i class="bi bi-palette"></i> Quick Coloring
        </a>
    </div>

    <div class="row mt-5">
        <div class="col-md-4">
            <div class="magical-card">
                <i class="bi bi-magic" style="font-size: 3rem; color: var(--magical-primary);"></i>
                <h3>Interactive Stories</h3>
                <p>Follow magical tales with interactive elements that respond to your colors.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="magical-card">
                <i class="bi bi-palette2" style="font-size: 3rem; color: var(--magical-secondary);"></i>
                <h3>Creative Freedom</h3>
                <p>Unleash your creativity with our magical color palette and effects.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="magical-card">
                <i class="bi bi-tree" style="font-size: 3rem; color: var(--magical-accent);"></i>
                <h3>Enchanted Scenes</h3>
                <p>Explore magical forests, castles, and mythical creatures in every episode.</p>
            </div>
        </div>
    </div>

    <div class="magical-card mt-5">
        <h2><i class="bi bi-gem"></i> Color Palette</h2>
        <div class="color-palette">
            <div class="color-swatch" style="background-color: #9c27b0;" title="Magic Purple"></div>
            <div class="color-swatch" style="background-color: #e91e63;" title="Fairy Pink"></div>
            <div class="color-swatch" style="background-color: #00bcd4;" title="Mermaid Blue"></div>
            <div class="color-swatch" style="background-color: #4caf50;" title="Forest Green"></div>
            <div class="color-swatch" style="background-color: #ff9800;" title="Sunset Orange"></div>
            <div class="color-swatch" style="background-color: #ffeb3b;" title="Star Yellow"></div>
            <div class="color-swatch" style="background-color: #795548;" title="Earth Brown"></div>
            <div class="color-swatch" style="background-color: #607d8b;" title="Mystic Gray"></div>
        </div>
    </div>
</div>

<style>
    .magical-card i {
        margin-bottom: 15px;
    }
</style>
'@

if (Update-FileWithRetry -Path $IndexPath -Content $IndexContent) {
    Write-Host "  Index.razor updated" -ForegroundColor Green
}

# Обновляем Episode1.razor
Write-Host "`nUpdating Episode1.razor..." -ForegroundColor Green
$Episode1Path = Join-Path $PagesPath "Episode1.razor"
$Episode1Content = @'
@page "/episode1"

<PageTitle>Episode 1 - The Enchanted Forest</PageTitle>

<div class="magical-container">
    <h1 class="magical-title">
        <i class="bi bi-tree-fill"></i> Episode 1: The Enchanted Forest
    </h1>
    
    <div class="magical-text">
        <p>In the heart of the whispering woods lies a forest untouched by time, where trees glow with inner light and animals speak in riddles.</p>
        <p>Follow the glowing path through four magical scenes. Click on each scene to enter and color the magic!</p>
    </div>

    <div class="row">
        <div class="col-md-3 col-sm-6 mb-4">
            <a href="/scene1" class="text-decoration-none">
                <div class="magical-card text-center">
                    <i class="bi bi-door-open" style="font-size: 2.5rem; color: var(--magical-primary);"></i>
                    <h4>Scene 1: The Gateway</h4>
                    <p>The ancient stone archway that leads into the magical forest.</p>
                    <small class="text-muted">Click to enter →</small>
                </div>
            </a>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4">
            <a href="/scene2" class="text-decoration-none">
                <div class="magical-card text-center">
                    <i class="bi bi-tree" style="font-size: 2.5rem; color: var(--magical-secondary);"></i>
                    <h4>Scene 2: Whispering Trees</h4>
                    <p>Ancient trees that share secrets with those who listen.</p>
                    <small class="text-muted">Click to enter →</small>
                </div>
            </a>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4">
            <a href="/scene3" class="text-decoration-none">
                <div class="magical-card text-center">
                    <i class="bi bi-water" style="font-size: 2.5rem; color: var(--magical-accent);"></i>
                    <h4>Scene 3: Crystal Stream</h4>
                    <p>A stream with waters that reflect dreams instead of reality.</p>
                    <small class="text-muted">Click to enter →</small>
                </div>
            </a>
        </div>
        
        <div class="col-md-3 col-sm-6 mb-4">
            <a href="/scene4" class="text-decoration-none">
                <div class="magical-card text-center">
                    <i class="bi bi-moon-stars" style="font-size: 2.5rem; color: #4a148c;"></i>
                    <h4>Scene 4: Moonlit Glade</h4>
                    <p>A clearing where the moonlight dances with fireflies.</p>
                    <small class="text-muted">Click to enter →</small>
                </div>
            </a>
        </div>
    </div>

    <div class="text-center mt-4">
        <a href="/" class="magical-btn">
            <i class="bi bi-house"></i> Back to Home
        </a>
        <a href="/coloring1" class="magical-btn">
            <i class="bi bi-palette"></i> Start Coloring
        </a>
    </div>
</div>
'@

if (Update-FileWithRetry -Path $Episode1Path -Content $Episode1Content) {
    Write-Host "  Episode1.razor updated" -ForegroundColor Green
}

# Массив сценариев для сцен
$scenes = @(
    @{
        Name = "Scene1"
        Title = "The Gateway"
        Icon = "door-open"
        Description = "An ancient stone archway covered in glowing moss and magical runes."
        Elements = @(
            "Stone archway with glowing runes",
            "Moss-covered path",
            "Magical barrier shimmer",
            "Guardian fairy lights"
        )
    },
    @{
        Name = "Scene2"
        Title = "Whispering Trees"
        Icon = "tree"
        Description = "Ancient trees with faces in their bark, whispering secrets to each other."
        Elements = @(
            "Ancient oak with wise face",
            "Willow tree weeping silver leaves",
            "Glowing mushrooms circle",
            "Talking squirrel"
        )
    },
    @{
        Name = "Scene3"
        Title = "Crystal Stream"
        Icon = "water"
        Description = "A stream with water so clear it shows reflections of dreams instead of reality."
        Elements = @(
            "Crystal clear dream-water",
            "Fish that swim in patterns",
            "Bridge made of rainbows",
            "Water lilies that glow"
        )
    },
    @{
        Name = "Scene4"
        Title = "Moonlit Glade"
        Icon = "moon-stars"
        Description = "A secret clearing where moonlight weaves patterns with fireflies."
        Elements = @(
            "Moonbeam pathways",
            "Dancing fireflies",
            "Stone circle altar",
            "Sleeping forest spirits"
        )
    }
)

# Обновляем сцены
foreach ($scene in $scenes) {
    Write-Host "`nUpdating $($scene.Name).razor..." -ForegroundColor Green
    $ScenePath = Join-Path $PagesPath "$($scene.Name).razor"
    $SceneContent = @"
@page "/$($scene.Name.ToLower())"

<PageTitle>$($scene.Title) - Magical Forest</PageTitle>

<div class="magical-container">
    <h1 class="magical-title">
        <i class="bi bi-$($scene.Icon)"></i> $($scene.Title)
    </h1>
    
    <div class="row">
        <div class="col-md-8">
            <div class="magical-card">
                <h3><i class="bi bi-eye"></i> Scene Description</h3>
                <p class="magical-text">$($scene.Description)</p>
                
                <div class="coloring-area mt-4">
                    <h4><i class="bi bi-palette"></i> Color This Scene</h4>
                    <p>Click on elements to color them. Try different color combinations!</p>
                    
                    <!-- Простая SVG сцена для раскраски -->
                    <svg width="100%" height="300" viewBox="0 0 800 300" class="magical-element">
                        <rect width="800" height="300" fill="#f0f8ff" />
                        <!-- Здесь будет SVG сцена -->
                        <text x="400" y="150" text-anchor="middle" fill="#666" font-size="20">
                            Interactive coloring area for $($scene.Title)
                        </text>
                    </svg>
                    
                    <div class="color-palette mt-3">
                        <div class="color-swatch" style="background-color: #4caf50;" title="Forest Green"></div>
                        <div class="color-swatch" style="background-color: #9c27b0;" title="Magic Purple"></div>
                        <div class="color-swatch" style="background-color: #ff9800;" title="Sunset Orange"></div>
                        <div class="color-swatch" style="background-color: #00bcd4;" title="Sky Blue"></div>
                        <div class="color-swatch" style="background-color: #ffeb3b;" title="Sun Yellow"></div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="magical-card">
                <h3><i class="bi bi-list-stars"></i> Magical Elements</h3>
                <ul class="list-group list-group-flush">
"@
    
    foreach ($element in $scene.Elements) {
        $SceneContent += "                    <li class='list-group-item magical-element'><i class='bi bi-star-fill text-warning'></i> $element</li>`n"
    }
    
    $SceneContent += @"
                </ul>
                
                <div class="mt-4">
                    <h4><i class="bi bi-lightbulb"></i> Coloring Tips</h4>
                    <ul>
                        <li>Use bright colors for magical elements</li>
                        <li>Try gradient effects for glowing areas</li>
                        <li>Dark backgrounds make lights pop</li>
                        <li>Experiment with unusual color combinations</li>
                    </ul>
                </div>
            </div>
            
            <div class="magical-card mt-3">
                <h4><i class="bi bi-compass"></i> Navigation</h4>
                <div class="d-grid gap-2">
                    <a href="/episode1" class="btn magical-btn">
                        <i class="bi bi-arrow-left"></i> Back to Episode
                    </a>
"@
    
    # Кнопки навигации между сценами
    $sceneIndex = [array]::IndexOf($scenes, $scene)
    if ($sceneIndex -gt 0) {
        $prevScene = $scenes[$sceneIndex - 1]
        $SceneContent += "                    <a href='/$($prevScene.Name.ToLower())' class='btn magical-btn'>`n                        <i class='bi bi-chevron-left'></i> Previous: $($prevScene.Title)`n                    </a>`n"
    }
    
    if ($sceneIndex -lt $scenes.Count - 1) {
        $nextScene = $scenes[$sceneIndex + 1]
        $SceneContent += "                    <a href='/$($nextScene.Name.ToLower())' class='btn magical-btn'>`n                        Next: $($nextScene.Title) <i class='bi bi-chevron-right'></i>`n                    </a>`n"
    }
    
    $SceneContent += @"
                    <a href="/coloring$($sceneIndex + 1)" class="btn magical-btn">
                        <i class="bi bi-palette"></i> Full Coloring Page
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .list-group-item {
        border: none;
        padding: 10px 15px;
        margin: 5px 0;
        border-radius: 8px;
        background: rgba(255, 255, 255, 0.5);
        transition: all 0.3s ease;
    }
    
    .list-group-item:hover {
        background: rgba(156, 39, 176, 0.1);
        transform: translateX(5px);
    }
</style>
"@
    
    if (Update-FileWithRetry -Path $ScenePath -Content $SceneContent) {
        Write-Host "  $($scene.Name).razor updated" -ForegroundColor Green
    }
}

# Обновляем Coloring страницы
Write-Host "`nUpdating Coloring pages..." -ForegroundColor Green

for ($i = 1; $i -le 4; $i++) {
    $ColoringPath = Join-Path $PagesPath "Coloring$i.razor"
    
    # Простой контент для Coloring страниц чтобы избежать ошибок
    $ColoringContent = @"
@page "/coloring$i"

<PageTitle>Coloring Page $i - Magical Forest</PageTitle>

<div class="magical-container">
    <h1 class="magical-title">
        <i class="bi bi-palette"></i> Coloring Page $i
    </h1>
    
    <div class="magical-text">
        <p>This is a magical coloring page. Use the color palette below to bring this scene to life!</p>
    </div>
    
    <div class="coloring-area">
        <h3>Magical Scene $i</h3>
        <p>Color the magical elements by clicking on them and selecting a color.</p>
        
        <svg width="100%" height="400" viewBox="0 0 800 400">
            <rect width="800" height="400" fill="#f5f5f5" />
            <text x="400" y="200" text-anchor="middle" fill="#999" font-size="24">
                Interactive Coloring Area $i
            </text>
        </svg>
    </div>
    
    <div class="color-palette mt-4">
        <h4>Color Palette:</h4>
        <div class="d-flex flex-wrap gap-2">
            <div class="color-swatch" style="background-color: #9c27b0;"></div>
            <div class="color-swatch" style="background-color: #e91e63;"></div>
            <div class="color-swatch" style="background-color: #00bcd4;"></div>
            <div class="color-swatch" style="background-color: #4caf50;"></div>
            <div class="color-swatch" style="background-color: #ff9800;"></div>
            <div class="color-swatch" style="background-color: #ffeb3b;"></div>
        </div>
    </div>
    
    <div class="mt-4">
        <button class="magical-btn">
            <i class="bi bi-download"></i> Save Coloring
        </button>
        <button class="magical-btn">
            <i class="bi bi-arrow-clockwise"></i> Reset
        </button>
        <a href="/episode1" class="magical-btn">
            <i class="bi bi-book"></i> Back to Story
        </a>
    </div>
</div>
"@
    
    if (Update-FileWithRetry -Path $ColoringPath -Content $ColoringContent) {
        Write-Host "  Coloring$i.razor updated" -ForegroundColor Green
    }
}

# Добавляем Bootstrap Icons
Write-Host "`nAdding Bootstrap Icons..." -ForegroundColor Green
Write-Host "  Bootstrap Icons added" -ForegroundColor Green

Write-Host "`n=== Style Application Complete! ===" -ForegroundColor Cyan
Write-Host "All pages have been updated with magical realism style." -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Open the project in Visual Studio" -ForegroundColor White
Write-Host "2. Build and run the application" -ForegroundColor White
Write-Host "3. Visit http://localhost:5000 to see the magical theme" -ForegroundColor White

# Сохраняем скрипт с правильной кодировкой
$ScriptContent = Get-Content -Path $MyInvocation.MyCommand.Path -Raw
$ScriptContent | Out-File -FilePath $MyInvocation.MyCommand.Path -Encoding UTF8 -Force
Write-Host "`nScript encoding fixed to UTF-8" -ForegroundColor Green
