# Pi Setup

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Bootstrap script for pi coding agent with custom configuration.

**Cross-platform support:** macOS, Linux, WSL, and native Windows (PowerShell)

## What This Sets Up

- Pi coding agent (global npm install)
- pi-superpowers package (skills: TDD, debugging, code review, etc.)
- pi-listen package (voice input with parakeet-v2 model)
- Custom settings (ZhipuAI/GLM-5 default, voice enabled)

## Quick Start

1. Clone this repo:
   ```bash
   git clone https://github.com/cartsp/pi-setup.git
   cd pi-setup
   ```

2. Run setup:
   ```bash
   # macOS/Linux/WSL
   chmod +x setup.sh
   ./setup.sh

   # Windows PowerShell (native)
   .\setup.ps1
   ```

3. Add your API keys:
   ```bash
   # macOS/Linux/WSL
   nano ~/.pi/agent/auth.json

   # Windows
   notepad %USERPROFILE%\.pi\agent\auth.json
   ```

4. Start pi:
   ```bash
   pi
   ```

## Prerequisites

- Node.js 18+
- npm
- Git

### Windows Notes
- Run PowerShell as Administrator for global npm installs
- Or configure npm to use user directory: `npm config set prefix "$env:APPDATA\npm"`

## What Gets Configured

- `~/.pi/agent/settings.json` (Unix) or `%USERPROFILE%\.pi\agent\settings.json` (Windows) - Pi configuration
- `~/.pi/agent/auth.json` (Unix) or `%USERPROFILE%\.pi\agent\auth.json` (Windows) - Authentication (you add keys)
- Global npm packages: @mariozechner/pi-coding-agent
- Pi packages: pi-superpowers, pi-listen

## Customization

Edit `config/settings.template.json` before running setup to change:
- **Default provider/model** - Currently set to ZhipuAI/GLM-5
- **Voice settings** - Enabled, English, local backend
- **Package list** - Add or remove pi packages

You can also edit the config files after setup:
- `~/.pi/agent/settings.json` (Unix)
- `%USERPROFILE%\.pi\agent\settings.json` (Windows)

## Re-running

Safe to run multiple times. Existing config will be backed up.

## Troubleshooting

- Run `pi --version` to verify installation
- Check config file exists:
  - Unix: `~/.pi/agent/settings.json`
  - Windows: `%USERPROFILE%\.pi\agent\settings.json`
- Ensure Node.js 18+ is in your PATH
- On Windows, try running PowerShell as Administrator if npm install fails

## Tested Platforms

- macOS (Sonoma, Ventura)
- WSL 2 (Ubuntu 22.04)
- Linux (Ubuntu 22.04, Debian 12)
- Windows 10/11 (PowerShell 5.1+)

## Voice Model

The parakeet-v2 voice model downloads automatically on first voice input (~661MB).

For model details and manual download instructions:
- Unix: `./voice/download-model.sh`
- Windows: `.\voice\download-model.ps1` (informational only)

## What the Setup Script Does

1. **Checks prerequisites** - Verifies Node.js 18+, npm, and Git are installed
2. **Installs pi** - Installs `@mariozechner/pi-coding-agent` globally via npm
3. **Configures settings** - Copies templates to `~/.pi/agent/` (or `%USERPROFILE%\.pi\agent\` on Windows)
4. **Backs up existing config** - If config exists, creates timestamped backup
5. **Installs packages** - Installs pi-superpowers and pi-listen
6. **Sets voice config** - Enables voice input with parakeet-v2 model
