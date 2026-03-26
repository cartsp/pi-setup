#!/bin/bash
# Pi Setup - Bootstrap your pi environment
# Usage: ./setup.sh [--force]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Detect platform
detect_platform() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
    else
        echo "linux"
    fi
}

PLATFORM=$(detect_platform)

check_prerequisites() {
    echo -e "${GREEN}✓${NC} Checking prerequisites..."

    # Node.js 18+
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js is not installed${NC}"
        echo "   Install from: https://nodejs.org/ (LTS version)"
        exit 1
    fi

    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [[ $NODE_VERSION -lt 18 ]]; then
        echo -e "${RED}❌ Node.js version too old: $(node -v)${NC}"
        echo "   Requires Node.js 18 or higher"
        exit 1
    fi
    echo "  Node.js: $(node -v)"

    # npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}❌ npm is not installed${NC}"
        exit 1
    fi
    echo "  npm: $(npm -v)"

    # Git
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git is not installed${NC}"
        exit 1
    fi
    echo "  Git: $(git --version | cut -d' ' -f3)"

    echo "  Platform: $PLATFORM"
    echo ""
}

install_pi() {
    echo -e "${GREEN}✓${NC} Installing pi..."

    # Check if already installed
    if command -v pi &> /dev/null; then
        if [[ "$1" == "--force" ]]; then
            echo "  Force reinstalling..."
            npm uninstall -g @mariozechner/pi-coding-agent
        else
            echo "  Pi already installed ($(pi --version)), skipping..."
            echo "  Use --force to reinstall"
            return 0
        fi
    fi

    # Install pi
    npm install -g @mariozechner/pi-coding-agent

    # Verify installation
    if ! command -v pi &> /dev/null; then
        echo -e "${RED}❌ Pi installation failed${NC}"
        exit 2
    fi

    echo "  Pi $(pi --version) installed"
    echo ""
}

configure_settings() {
    echo -e "${GREEN}✓${NC} Configuring settings..."

    # Create .pi directory
    mkdir -p "$HOME/.pi/agent"

    # Backup existing settings if present
    if [[ -f "$HOME/.pi/agent/settings.json" ]]; then
        BACKUP_FILE="$HOME/.pi/agent/settings.json.backup.$(date +%s)"
        echo "  Backing up existing settings to: $(basename $BACKUP_FILE)"
        mv "$HOME/.pi/agent/settings.json" "$BACKUP_FILE"
    fi

    # Copy settings template
    cp "$SCRIPT_DIR/config/settings.template.json" "$HOME/.pi/agent/settings.json"

    # Set completedAt timestamp
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    if [[ "$PLATFORM" == "macos" ]]; then
        # macOS sed
        sed -i '' "s/\"completedAt\": \"\"/\"completedAt\": \"$TIMESTAMP\"/" "$HOME/.pi/agent/settings.json"
    else
        # Linux sed
        sed -i "s/\"completedAt\": \"\"/\"completedAt\": \"$TIMESTAMP\"/" "$HOME/.pi/agent/settings.json"
    fi

    echo "  Settings: ~/.pi/agent/settings.json"

    # Backup existing auth if present
    if [[ -f "$HOME/.pi/agent/auth.json" ]]; then
        BACKUP_FILE="$HOME/.pi/agent/auth.json.backup.$(date +%s)"
        echo "  Backing up existing auth to: $(basename $BACKUP_FILE)"
        mv "$HOME/.pi/agent/auth.json" "$BACKUP_FILE"
    fi

    # Copy auth template
    cp "$SCRIPT_DIR/config/auth.template.json" "$HOME/.pi/agent/auth.json"

    echo "  Auth:     ~/.pi/agent/auth.json"
    echo ""
}

install_packages() {
    echo -e "${GREEN}✓${NC} Installing packages..."

    # Install pi-superpowers
    echo "  Installing pi-superpowers..."
    if ! pi install npm:@weiping/pi-superpowers; then
        echo -e "${YELLOW}⚠️  pi-superpowers installation may have failed${NC}"
    fi

    # Install pi-listen
    echo "  Installing pi-listen..."
    if ! pi install npm:@codexstar/pi-listen; then
        echo -e "${YELLOW}⚠️  pi-listen installation may have failed${NC}"
    fi

    # Verify installations
    if pi list 2>/dev/null | grep -q "pi-superpowers"; then
        echo "  ✓ pi-superpowers installed"
    fi

    if pi list 2>/dev/null | grep -q "pi-listen"; then
        echo "  ✓ pi-listen installed"
    fi

    echo ""
}

echo "Pi Setup - Bootstrap your pi environment"
echo ""

# Phase 1: Check prerequisites
check_prerequisites

# Phase 2: Install pi
install_pi "$1"

# Phase 3: Configure settings
configure_settings

# Phase 4: Install packages
install_packages

# Phase 5: Complete
echo -e "${GREEN}✓ Pi setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Add your API keys:"
echo "   nano ~/.pi/agent/auth.json"
echo ""
echo "2. Start pi:"
echo "   pi"
echo ""
echo "3. On first voice input, parakeet-v2 model will download (~661MB)"
echo ""
echo "Configuration:"
echo "  Settings: ~/.pi/agent/settings.json"
echo "  Auth:     ~/.pi/agent/auth.json"
echo "  Packages: pi-superpowers, pi-listen"
