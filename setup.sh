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

echo "Pi Setup - Bootstrap your pi environment"
echo ""

# Phase 1: Check prerequisites
check_prerequisites

# Phase 2: Install pi
install_pi "$1"

# TODO: Implement remaining phases
echo "Setup not yet implemented"
