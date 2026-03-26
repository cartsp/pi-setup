# Pi Setup - Bootstrap your pi environment (Windows PowerShell)
# Usage: .\setup.ps1 [-Force]

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Success { param($text) Write-Host "✓ $text" -ForegroundColor Green }
function Write-Error { param($text) Write-Host "❌ $text" -ForegroundColor Red }
function Write-Warning { param($text) Write-Host "⚠️  $text" -ForegroundColor Yellow }
function Write-Info { param($text) Write-Host "ℹ️  $text" -ForegroundColor Cyan }

# Get script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

# Detect platform
function Get-Platform {
    if ($env:OS -eq "Windows_NT") {
        return "windows"
    }
    return "unknown"
}

$PLATFORM = Get-Platform

# Check prerequisites
function Test-Prerequisites {
    Write-Success "Checking prerequisites..."

    # Node.js 18+
    $nodePath = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodePath) {
        Write-Error "Node.js is not installed"
        Write-Host "   Install from: https://nodejs.org/ (LTS version)"
        exit 1
    }

    $nodeVersion = (node -v) -replace 'v(\d+)\..*', '$1'
    if ([int]$nodeVersion -lt 18) {
        Write-Error "Node.js version too old: $(node -v)"
        Write-Host "   Requires Node.js 18 or higher"
        exit 1
    }
    Write-Host "  Node.js: $(node -v)"

    # npm
    $npmPath = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmPath) {
        Write-Error "npm is not installed"
        exit 1
    }
    Write-Host "  npm: $(npm -v)"

    # Git
    $gitPath = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitPath) {
        Write-Error "Git is not installed"
        Write-Host "   Install from: https://git-scm.com/download/win"
        exit 1
    }
    Write-Host "  Git: $(git --version).Split(' ')[2]"

    Write-Host "  Platform: $PLATFORM"
    Write-Host ""
}

# Install pi
function Install-Pi {
    Write-Success "Installing pi..."

    $piPath = Get-Command pi -ErrorAction SilentlyContinue

    if ($piPath) {
        if ($Force) {
            Write-Host "  Force reinstalling..."
            npm uninstall -g @mariozechner/pi-coding-agent
        } else {
            $version = pi --version 2>&1
            Write-Host "  Pi already installed ($version), skipping..."
            Write-Host "  Use -Force to reinstall"
            return
        }
    }

    # Install pi
    npm install -g @mariozechner/pi-coding-agent

    # Verify installation
    $piPath = Get-Command pi -ErrorAction SilentlyContinue
    if (-not $piPath) {
        Write-Error "Pi installation failed"
        exit 2
    }

    $version = pi --version 2>&1
    Write-Host "  Pi $version installed"
    Write-Host ""
}

# Configure settings
function Initialize-Settings {
    Write-Success "Configuring settings..."

    # Create .pi directory
    $piDir = "$env:USERPROFILE\.pi\agent"
    New-Item -ItemType Directory -Force -Path $piDir | Out-Null

    # Backup existing settings if present
    $settingsFile = "$piDir\settings.json"
    if (Test-Path $settingsFile) {
        $backupFile = "$settingsFile.backup.$(Get-Date -UFormat %s)"
        Write-Host "  Backing up existing settings to: $(Split-Path $backupFile -Leaf)"
        Move-Item $settingsFile $backupFile
    }

    # Copy settings template
    $templateFile = "$SCRIPT_DIR\config\settings.template.json"
    Copy-Item $templateFile $settingsFile

    # Set completedAt timestamp
    $timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ss.fffZ"
    $content = Get-Content $settingsFile -Raw
    $content = $content -replace '"completedAt": ""', "`"completedAt`": `"$timestamp`""
    Set-Content $settingsFile $content

    Write-Host "  Settings: $settingsFile"

    # Backup existing auth if present
    $authFile = "$piDir\auth.json"
    if (Test-Path $authFile) {
        $backupFile = "$authFile.backup.$(Get-Date -UFormat %s)"
        Write-Host "  Backing up existing auth to: $(Split-Path $backupFile -Leaf)"
        Move-Item $authFile $backupFile
    }

    # Copy auth template
    $authTemplate = "$SCRIPT_DIR\config\auth.template.json"
    Copy-Item $authTemplate $authFile

    Write-Host "  Auth:     $authFile"
    Write-Host ""
}

# Install packages
function Install-Packages {
    Write-Success "Installing packages..."

    # Install pi-superpowers
    Write-Host "  Installing pi-superpowers..."
    $result = pi install npm:@weiping/pi-superpowers 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "pi-superpowers installation may have failed"
    }

    # Install pi-listen
    Write-Host "  Installing pi-listen..."
    $result = pi install npm:@codexstar/pi-listen 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "pi-listen installation may have failed"
    }

    # Verify installations
    $packages = pi list 2>&1
    if ($packages -match "pi-superpowers") {
        Write-Host "  ✓ pi-superpowers installed"
    }

    if ($packages -match "pi-listen") {
        Write-Host "  ✓ pi-listen installed"
    }

    Write-Host ""
}

# Main execution
Write-Host "Pi Setup - Bootstrap your pi environment (Windows)" -ForegroundColor Cyan
Write-Host ""

# Phase 1: Check prerequisites
Test-Prerequisites

# Phase 2: Install pi
Install-Pi

# Phase 3: Configure settings
Initialize-Settings

# Phase 4: Install packages
Install-Packages

# Phase 5: Complete
Write-Success "Pi setup complete!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Add your API keys:"
Write-Host "   notepad $env:USERPROFILE\.pi\agent\auth.json"
Write-Host ""
Write-Host "2. Start pi:"
Write-Host "   pi"
Write-Host ""
Write-Host "3. On first voice input, parakeet-v2 model will download (~661MB)"
Write-Host ""
Write-Host "Configuration:"
Write-Host "  Settings: $env:USERPROFILE\.pi\agent\settings.json"
Write-Host "  Auth:     $env:USERPROFILE\.pi\agent\auth.json"
Write-Host "  Packages: pi-superpowers, pi-listen"
