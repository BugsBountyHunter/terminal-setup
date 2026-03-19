# macOS Terminal Setup — Complete Guide

A full guide to transforming a plain macOS zsh terminal into a modern,
productive developer environment using iTerm2, Powerlevel10k, and best-in-class
CLI tools.

> **Quick setup:** Run `setup.sh` to automate the entire installation.
> See [Running the Setup Script](#running-the-setup-script) for instructions.

---

## Table of Contents

1. [Overview](#overview)
2. [What Gets Installed](#what-gets-installed)
3. [Step 1 — Install Homebrew](#step-1--install-homebrew)
4. [Step 2 — Install iTerm2](#step-2--install-iterm2)
5. [Step 3 — Install Oh My Zsh](#step-3--install-oh-my-zsh)
6. [Step 4 — Install Powerlevel10k](#step-4--install-powerlevel10k)
7. [Step 5 — Install Nerd Font](#step-5--install-nerd-font)
8. [Step 6 — Set Font in iTerm2](#step-6--set-font-in-iterm2)
9. [Step 7 — Install Modern CLI Tools](#step-7--install-modern-cli-tools)
10. [Step 8 — Install zsh Plugins](#step-8--install-zsh-plugins)
11. [Step 9 — Configure .zshrc](#step-9--configure-zshrc)
12. [Step 10 — Configure Powerlevel10k Prompt](#step-10--configure-powerlevel10k-prompt)
13. [Running the Setup Script](#running-the-setup-script)
14. [Tool Reference & Cheat Sheet](#tool-reference--cheat-sheet)
15. [Aliases Reference](#aliases-reference)
16. [Troubleshooting](#troubleshooting)

---

## Overview

macOS Terminal.app is limited: no true color, poor font rendering, no icon
support. This guide replaces it with a fully featured stack:

| Layer | Tool | Purpose |
|-------|------|---------|
| Terminal app | iTerm2 | True color, fonts, splits, profiles |
| Shell framework | Oh My Zsh | Plugin management, completions |
| Prompt | Powerlevel10k | Fast, beautiful, git-aware prompt |
| Font | MesloLGS Nerd Font | Icons and powerline glyphs |
| File listing | eza | Replaces `ls` with color, icons, git info |
| File viewing | bat | Replaces `cat` with syntax highlighting |
| File search | fd | Replaces `find` — 10x faster |
| Directory jump | zoxide | Smarter `cd` with frecency tracking |
| Fuzzy finder | fzf | Interactive search with live preview |

---

## What Gets Installed

**Homebrew casks:**
- `iterm2` — terminal emulator
- `font-meslo-lg-nerd-font` — icon-capable font

**Homebrew formulae:**
- `eza` — modern ls
- `bat` — modern cat
- `fd` — modern find
- `zoxide` — smarter cd

**Oh My Zsh plugins (cloned manually):**
- `zsh-autosuggestions` — fish-style command suggestions
- `zsh-syntax-highlighting` — real-time command coloring

**Oh My Zsh theme:**
- `powerlevel10k` — the prompt engine

---

## Step 1 — Install Homebrew

Homebrew is the package manager for macOS. Skip if already installed.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Verify:

```bash
brew --version
```

---

## Step 2 — Install iTerm2

macOS Terminal.app does not support Nerd Fonts properly. iTerm2 does.

```bash
brew install --cask iterm2
```

Open iTerm2 from Spotlight (`Cmd+Space` → type `iTerm`).

**Why iTerm2 over Terminal.app:**
- Full 24-bit true color support
- Proper Nerd Font rendering (icons work)
- Split panes, tabs, profiles
- Shell integration (click to jump to commands)
- Better performance with large output

---

## Step 3 — Install Oh My Zsh

Oh My Zsh manages zsh plugins and themes.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Verify:

```bash
echo $ZSH
# Should output: /Users/<you>/.oh-my-zsh
```

---

## Step 4 — Install Powerlevel10k

Powerlevel10k is the theme. It renders asynchronously so your prompt never
lags, even in large git repos.

```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

Then install the two required community plugins:

```bash
# Auto-suggestions (fish-style grey completions)
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Syntax highlighting (commands turn green/red as you type)
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

---

## Step 5 — Install Nerd Font

Nerd Fonts patch standard fonts with thousands of icons used by eza, p10k, etc.

```bash
brew install --cask font-meslo-lg-nerd-font
```

The font files are installed to `~/Library/Fonts/` automatically.

---

## Step 6 — Set Font in iTerm2

The font must be set manually in iTerm2 preferences:

1. Open iTerm2
2. Press `Cmd+,` to open Preferences
3. Go to **Profiles → Text**
4. Click the **Font** dropdown
5. Search for and select **MesloLGS Nerd Font**
6. Set size to **14**
7. Close Preferences

> Without this step, icons will appear as boxes or question marks.

---

## Step 7 — Install Modern CLI Tools

```bash
brew install eza bat fd zoxide
```

| Tool | Replaces | Key improvement |
|------|----------|-----------------|
| `eza` | `ls` | Color, icons, git status per file, tree view |
| `bat` | `cat` | Syntax highlighting, line numbers, git diff markers |
| `fd` | `find` | 10x faster, `.gitignore`-aware, intuitive syntax |
| `zoxide` | `cd` + `z` | Learns your most-used dirs, jump with partial names |

---

## Step 8 — Install zsh Plugins

The two community plugins (autosuggestions + syntax highlighting) were cloned in
Step 4. They are activated by listing them in `~/.zshrc` plugins array:

```zsh
plugins=(
  git
  node
  npm
  docker
  docker-compose
  command-not-found
  history-substring-search
  colorize
  sudo
  extract
  macos
  zsh-autosuggestions        # <-- community plugin
  zsh-syntax-highlighting    # <-- community plugin
)
```

**What each built-in plugin does:**

| Plugin | What it adds |
|--------|-------------|
| `git` | Git aliases: `gst`, `gco`, `gcmsg`, etc. |
| `history-substring-search` | Up/Down arrows search history by prefix |
| `colorize` | `ccat` command with syntax coloring |
| `sudo` | Press `Esc` twice to prepend `sudo` to last command |
| `extract` | `extract <file>` works on any archive format |
| `macos` | macOS-specific shortcuts like `ofd` (open Finder here) |
| `command-not-found` | Suggests brew install when command is missing |
| `zsh-autosuggestions` | Grey ghost text as you type, `→` to accept |
| `zsh-syntax-highlighting` | Colors commands red (invalid) or green (valid) |

---

## Step 9 — Configure .zshrc

The full `~/.zshrc` configuration with explanations:

### Powerlevel10k instant prompt
Must be at the very top. Renders the prompt before zsh fully loads for
zero-lag startup.

```zsh
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```

### Oh My Zsh setup

```zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7
```

### History settings

```zsh
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS      # No duplicate entries
setopt HIST_IGNORE_SPACE     # Leading space = not saved
setopt HIST_FIND_NO_DUPS     # No duplicates in search
setopt HIST_REDUCE_BLANKS    # Strip extra whitespace
setopt SHARE_HISTORY         # Share across all open terminals
setopt APPEND_HISTORY        # Append, don't overwrite
```

Default zsh history is only 1000 lines. This raises it to 100,000 and
ensures history is shared instantly across all open terminals.

### zoxide init

```zsh
eval "$(zoxide init zsh)"
```

Initializes zoxide, which hooks into `cd` to track your directory visits.

### fzf configuration

```zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

export FZF_DEFAULT_OPTS="
  --height 50%
  --layout=reverse
  --border
  --preview '([[ -d {} ]] && eza --tree --color=always {} || bat --color=always --style=numbers {}) 2>/dev/null'
  --preview-window=right:55%:wrap
  --bind 'ctrl-/:toggle-preview'
"
```

- Uses `fd` instead of `find` as the backend (faster, respects `.gitignore`)
- Previews files with `bat` (syntax highlighted)
- Previews directories with `eza` (tree view)
- `Ctrl+/` toggles the preview pane

### eza aliases

```zsh
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --color=always --group-directories-first --icons --git'
alias lt='eza --tree --color=always --icons --level=2'
alias la='eza -a --color=always --group-directories-first --icons'
alias l='eza -1 --color=always --icons'
```

### bat aliases

```zsh
alias cat='bat --style=auto'
alias catp='bat --plain'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
```

`MANPAGER` makes `man` pages syntax-highlighted.

### Completion settings

```zsh
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
```

Enables interactive menu completion and case-insensitive tab completion.

---

## Step 10 — Configure Powerlevel10k Prompt

Run the interactive wizard:

```bash
p10k configure
```

**Recommended choices:**

| Question | Answer |
|----------|--------|
| Prompt style | Rainbow |
| Character set | Unicode |
| Show current time | 12-hour |
| Prompt separators | Angled |
| Prompt heads | Sharp |
| Prompt tails | Flat |
| Prompt height | Two lines |
| Prompt connection | Disconnected |
| Prompt frame | No frame |
| Transient prompt | No |
| Instant prompt | Verbose |

These choices produce a clean 2-line prompt:
- **Line 1:** OS icon → current directory → git branch/status → right: time + exit code
- **Line 2:** `❯` cursor (green on success, red on failure)

After the wizard, the config is saved to `~/.p10k.zsh`. You can re-run
`p10k configure` at any time to change the style.

To apply changes without restarting:

```bash
source ~/.p10k.zsh
```

---

## Running the Setup Script

The `setup.sh` script in this directory automates Steps 1–9 above. It:

- Checks for and installs Homebrew if missing
- Installs iTerm2 and the Nerd Font
- Installs Oh My Zsh (skips if already installed)
- Installs Powerlevel10k and community plugins
- Installs eza, bat, fd, zoxide
- Backs up your existing `.zshrc` and writes the new one
- Applies the recommended Powerlevel10k configuration

**Usage:**

```bash
cd ~/terminal-setup
chmod +x setup.sh
./setup.sh
```

After the script finishes, two manual steps remain:

1. **Set the font in iTerm2** — see [Step 6](#step-6--set-font-in-iterm2)
2. **Source and configure** — in a new iTerm2 window:
   ```bash
   source ~/.zshrc
   p10k configure   # pick the recommended choices from Step 10
   ```

---

## Tool Reference & Cheat Sheet

### eza — file listing

```bash
ls              # basic listing with icons
ll              # long list + git status
la              # show hidden files
lt              # tree view (2 levels deep)
l               # one file per line
lt --level=3    # tree 3 levels deep
ll --sort=size  # sort by size
```

### bat — file viewing

```bash
cat file.js         # syntax highlighted view
catp file.js        # plain, no decorations
bat -l json file    # force language
bat --diff file     # show git diff inline
man ls              # colorized man page
```

### fd — file search

```bash
fd pattern              # find files matching pattern
fd -e js                # find by extension
fd -t d name            # find directories
fd -H pattern           # include hidden files
fd pattern src/         # search in specific dir
fd -x cmd               # run command on each result
```

### zoxide — smart directory jump

```bash
z projects          # jump to best match for "projects"
z pro doc           # multi-word match
zi                  # interactive fuzzy picker (uses fzf)
z -                 # jump to previous directory
zoxide query -l     # list all known directories with scores
```

### fzf — fuzzy finder

| Shortcut | Action |
|----------|--------|
| `Ctrl+T` | Insert a file path at cursor |
| `Ctrl+R` | Search command history |
| `Alt+C` | cd into a directory |
| `Ctrl+/` | Toggle preview pane |
| `Tab` | Multi-select |

---

## Aliases Reference

### File operations
| Alias | Command |
|-------|---------|
| `ls` | `eza --color=always --group-directories-first --icons` |
| `ll` | `eza -la ... --git` |
| `lt` | `eza --tree --level=2` |
| `la` | `eza -a ...` |
| `cat` | `bat --style=auto` |
| `catp` | `bat --plain` |

### Git
| Alias | Command |
|-------|---------|
| `gs` | `git status -sb` |
| `gd` | `git diff` |
| `gds` | `git diff --staged` |
| `gl` | `git log --oneline --graph --decorate -20` |
| `gla` | `git log --oneline --graph --decorate --all -30` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `gp` | `git push` |
| `gpl` | `git pull` |
| `ga` | `git add` |
| `gaa` | `git add -A` |
| `gc` | `git commit` |
| `gcm` | `git commit -m` |

### Navigation
| Alias | Action |
|-------|--------|
| `..` | `cd ..` |
| `...` | `cd ../..` |
| `....` | `cd ../../..` |
| `~` | `cd ~` |

### Utilities
| Alias | Action |
|-------|--------|
| `reload` | Re-source `~/.zshrc` |
| `zshconfig` | Open `~/.zshrc` in editor |
| `path` | Print `$PATH` one entry per line |
| `ip` | Show public IP |
| `localip` | Show local network IP |
| `duh` | Directory sizes sorted by size |
| `cls` | Clear screen |

---

## Troubleshooting

### Icons show as boxes or `?`
The Nerd Font is not set in iTerm2.
Go to `Preferences → Profiles → Text → Font` and select **MesloLGS Nerd Font**.

### `p10k configure` wizard aborts immediately
You are running it inside macOS Terminal.app instead of iTerm2. Open iTerm2
and run it there.

### `zoxide: command not found`
Run `brew install zoxide`, then open a new terminal tab.

### `eza: command not found`
Run `brew install eza`, then open a new terminal tab.

### autosuggestions not appearing
The plugin was not cloned or is not in the plugins list.

```bash
# Clone if missing
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Verify it's in ~/.zshrc plugins list
grep autosuggestions ~/.zshrc
```

### zshrc changes not taking effect
Run `source ~/.zshrc` or open a new terminal tab.

### p10k prompt looks wrong after editing `.p10k.zsh`
Run `source ~/.p10k.zsh` to hot-reload without restarting the terminal.

### History not persisting across sessions
Verify these lines are in `~/.zshrc`:
```zsh
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt APPEND_HISTORY
```
