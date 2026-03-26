# Pi Setup

Bootstrap script for pi coding agent with custom configuration.

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
   chmod +x setup.sh
   ./setup.sh
   ```

3. Add your API keys:
   ```bash
   nano ~/.pi/agent/auth.json
   ```

4. Start pi:
   ```bash
   pi
   ```

## Prerequisites

- Node.js 18+
- npm
- Git

## What Gets Configured

- `~/.pi/agent/settings.json` - Pi configuration
- `~/.pi/agent/auth.json` - Authentication (you add keys)
- Global npm packages: @mariozechner/pi-coding-agent
- Pi packages: pi-superpowers, pi-listen

## Customization

Edit `config/settings.template.json` before running setup to change:
- Default provider/model
- Voice settings
- Package list

## Re-running

Safe to run multiple times. Existing config will be backed up.

## Troubleshooting

Run `pi --version` to verify installation.
Check `~/.pi/agent/settings.json` exists.

## Tested Platforms

- macOS (Sonoma, Ventura)
- WSL 2 (Ubuntu 22.04)
- Linux (Ubuntu 22.04, Debian 12)

## Voice Model

The parakeet-v2 voice model downloads automatically on first voice input (~661MB).

To check model status or trigger download manually, see `voice/download-model.sh`.
