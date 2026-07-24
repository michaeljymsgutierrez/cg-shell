# bashrc-cg

Personal dev environment configuration for macOS - Zsh, Ghostty, Neovim, Tmux, and supporting shell scripts.

> macOS only. Linux is not supported.

## Prerequisites

Install these first before anything else.

**Git** - comes pre-installed on macOS. If missing:
```bash
xcode-select --install
```

**Homebrew**
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**NVM**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
```

## Required Tools

### Homebrew Packages

```bash
brew install ghostty ripgrep neovim tmux jq tig bat
```

| NAME    | VERSION |
| :------ | ------: |
| ghostty |   1.2.0 |
| tmux    |     3.4 |

### superfile (spf)

TUI file manager. Requires a tap:

```bash
brew tap mhnightcat/superfile https://github.com/MHNightCat/homebrew-superfile.git && brew install superfile
```

### Node

```bash
nvm install --lts
nvm use --lts
```

### npm Global Packages

```bash
npm install -g @anthropic-ai/claude-code corepack dts-generator http-server jsdoc-to-markdown jsdoc pdf2json prettier typescript yarn
```

| NAME     | VERSION |
| :------- | ------: |
| prettier |   3.6.2 |

## Configuration

Steps to configure Zsh, Ghostty, Neovim, Lazy, Prettier, and Tmux.

### 1. Clone the Configuration Repository

```bash
git clone https://github.com/michaeljymsgutierrez/bashrc-cg ~/bashrc-cg
```

### 2. Install Fonts

Required for Ghostty and Neovim icons to render correctly.

```bash
cp ~/bashrc-cg/fonts/*.ttf ~/Library/Fonts/
```

### 3. Install fzf (Optional)

```bash
brew install fzf
```

### 4. Configure Zsh

Add to `~/.zshrc`:

```bash
source ~/bashrc-cg/path.cgf
source ~/bashrc-cg/prompt.cgf
source ~/bashrc-cg/alias.cgf
```

### 5. Configure Ghostty

Add to `~/.config/ghostty/config`:

```bash
config-file = "~/bashrc-cg/ghostty.cgf"
```

Custom GLSL shaders are available in `shaders/`. To enable one, uncomment the relevant `custom-shader` line in `ghostty.cgf`.

### 6. Configure Neovim

Add to `~/.config/nvim/init.lua`:

```lua
local homeDirectory = os.getenv('HOME') .. '/bashrc-cg/nvim-cgf.lua'
local initNvimConfig = loadfile(homeDirectory)
if initNvimConfig then initNvimConfig() end
```

### 7. Configure Tmux

Add to `~/.tmux.conf`:

```bash
source ~/bashrc-cg/tmux.cgf
```

The color theme (`tmux-colors/cg-theme.tmux`) is automatically sourced by `tmux.cgf` - no extra step needed.

### 8. Global Tooling Configs

```bash
cat ~/bashrc-cg/prettier.cgf > ~/.prettierrc
cat ~/bashrc-cg/lazy-lock.cgf > ~/.config/nvim/lazy-lock.json
cat ~/bashrc-cg/gitignore-global.cgf > ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global
cat ~/bashrc-cg/superfile.cgf > ~/Library/Application\ Support/superfile/config.toml
```

> superfile generates its config on first launch. Run `spf` once (then quit with `q`) before applying `superfile.cgf`. The `monokai` theme is built in, and `transparent_background` lets the tmux/terminal background show through.

### 9. Claude Code Config

```bash
git clone https://github.com/michaeljymsgutierrez/cg-claude ~/cg-claude
cd ~/cg-claude && ./pull.sh
```

`pull.sh` copies `CLAUDE.md`, `skills/`, and `plugins/known_marketplaces.json` from the repo into `~/.claude/`. Run `./push.sh` to sync changes back to the repo.

## Shell Scripts

Utility scripts in `shellscripts/` for system info, notifications, and maintenance. Used primarily as Tmux status bar widgets and system helpers.

| Script                         | Purpose                         |
| :----------------------------- | :------------------------------ |
| battery.sh                     | Battery level and status        |
| cpu.sh                         | CPU usage                       |
| memory.sh                      | Memory usage                    |
| network.sh                     | Network interface info          |
| date.sh / time.sh / timenow.sh | Date and time display           |
| calendar-notification-count.sh | Calendar notification count     |
| mail-notification-count.sh     | Mail notification count         |
| slack-notification-count.sh    | Slack notification count        |
| discord-notification.sh        | Discord notification count      |
| system-notification-count.sh   | System-wide notification count  |
| audio-restart.sh               | Restart core audio              |
| switch-ssh.sh                  | Switch between SSH key profiles |
| stopservices.sh                | Stop common dev services        |
| force-reboot.sh                | Force system reboot             |
| force-shutdown.sh              | Force system shutdown           |
| earth.sh / iconize-string.sh   | Terminal icon/string helpers    |
| set-icon.sh                    | Set app icon                    |

## Finalize and Restart

```bash
source ~/.zshrc # Apply Zsh changes
nvim            # Launch Neovim
```
