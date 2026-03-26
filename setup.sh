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

echo "Pi Setup - Bootstrap your pi environment"
echo ""

# TODO: Implement phases
echo "Setup not yet implemented"
