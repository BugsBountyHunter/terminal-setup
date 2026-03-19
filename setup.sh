#!/usr/bin/env bash
# =============================================================================
# macOS Terminal Setup Script
# Sets up iTerm2 + Oh My Zsh + Powerlevel10k + modern CLI tools from scratch.
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
#
# What this script does:
#   1. Installs Homebrew (if missing)
#   2. Installs iTerm2
#   3. Installs MesloLGS Nerd Font
#   4. Installs Oh My Zsh (if missing)
#   5. Installs Powerlevel10k theme
#   6. Installs zsh community plugins (autosuggestions, syntax-highlighting)
#   7. Installs modern CLI tools: eza, bat, fd, zoxide
#   8. Backs up existing ~/.zshrc and writes the new one
#   9. Applies recommended Powerlevel10k configuration to ~/.p10k.zsh
#
# After the script:
#   - Open iTerm2
#   - Set font: Preferences → Profiles → Text → MesloLGS Nerd Font (size 14)
#   - Run: source ~/.zshrc
#   - Run: p10k configure  (follow the recommended choices in README.md)
#
# Full documentation: README.md (in this directory)
# =============================================================================

set -e

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[OK]${RESET}  $1"; }
warn()    { echo -e "${YELLOW}[WARN]${RESET} $1"; }
step()    { echo -e "\n${BOLD}── $1 ──${RESET}"; }

# ── Helpers ───────────────────────────────────────────────────────────────────
command_exists() { command -v "$1" &>/dev/null; }

backup_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    warn "Backed up $file → $backup"
  fi
}

# ── Step 1: Homebrew ──────────────────────────────────────────────────────────
step "1/9 — Homebrew"

if command_exists brew; then
  success "Homebrew already installed"
else
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
  success "Homebrew installed"
fi

# ── Step 2: iTerm2 ────────────────────────────────────────────────────────────
step "2/9 — iTerm2"

if [[ -d "/Applications/iTerm.app" ]]; then
  success "iTerm2 already installed"
else
  info "Installing iTerm2..."
  brew install --cask iterm2
  success "iTerm2 installed"
fi

# ── Step 3: Nerd Font ─────────────────────────────────────────────────────────
step "3/9 — MesloLGS Nerd Font"

if ls ~/Library/Fonts/MesloLGS* &>/dev/null; then
  success "MesloLGS Nerd Font already installed"
else
  info "Installing MesloLGS Nerd Font..."
  brew install --cask font-meslo-lg-nerd-font
  success "Font installed"
fi

warn "ACTION REQUIRED: After this script finishes, set the font in iTerm2:"
warn "  Preferences → Profiles → Text → Font → MesloLGS Nerd Font → size 14"

# ── Step 4: Oh My Zsh ─────────────────────────────────────────────────────────
step "4/9 — Oh My Zsh"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  success "Oh My Zsh already installed"
else
  info "Installing Oh My Zsh..."
  # Install without auto-changing shell or launching new shell
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  success "Oh My Zsh installed"
fi

# ── Step 5: Powerlevel10k ─────────────────────────────────────────────────────
step "5/9 — Powerlevel10k theme"

P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

if [[ -d "$P10K_DIR" ]]; then
  success "Powerlevel10k already installed"
else
  info "Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
  success "Powerlevel10k installed"
fi

# ── Step 6: zsh community plugins ────────────────────────────────────────────
step "6/9 — zsh plugins"

CUSTOM_PLUGINS="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

if [[ -d "$CUSTOM_PLUGINS/zsh-autosuggestions" ]]; then
  success "zsh-autosuggestions already installed"
else
  info "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "$CUSTOM_PLUGINS/zsh-autosuggestions"
  success "zsh-autosuggestions installed"
fi

if [[ -d "$CUSTOM_PLUGINS/zsh-syntax-highlighting" ]]; then
  success "zsh-syntax-highlighting already installed"
else
  info "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting \
    "$CUSTOM_PLUGINS/zsh-syntax-highlighting"
  success "zsh-syntax-highlighting installed"
fi

# ── Step 7: Modern CLI tools ──────────────────────────────────────────────────
step "7/9 — Modern CLI tools (eza, bat, fd, zoxide)"

TOOLS=(eza bat fd zoxide)
TO_INSTALL=()

for tool in "${TOOLS[@]}"; do
  if command_exists "$tool"; then
    success "$tool already installed"
  else
    TO_INSTALL+=("$tool")
  fi
done

if [[ ${#TO_INSTALL[@]} -gt 0 ]]; then
  info "Installing: ${TO_INSTALL[*]}"
  brew install "${TO_INSTALL[@]}"
  success "Tools installed"
fi

# ── Step 8: Write ~/.zshrc ────────────────────────────────────────────────────
step "8/9 — Writing ~/.zshrc"

backup_file "$HOME/.zshrc"

cat > "$HOME/.zshrc" << 'ZSHRC'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ─────────────────────────────────────────────
#  Oh My Zsh
# ─────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# OMZ update: remind only
zstyle ':omz:update' mode reminder
zstyle ':omz:update' frequency 7

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
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ─────────────────────────────────────────────
#  Powerlevel10k
# ─────────────────────────────────────────────
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ─────────────────────────────────────────────
#  History
# ─────────────────────────────────────────────
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS        # Don't record duplicates
setopt HIST_IGNORE_SPACE       # Commands starting with space are not saved
setopt HIST_FIND_NO_DUPS       # No duplicates when searching
setopt HIST_REDUCE_BLANKS      # Remove extra blanks
setopt SHARE_HISTORY           # Share history across all sessions
setopt APPEND_HISTORY          # Append rather than overwrite

# ─────────────────────────────────────────────
#  Completion
# ─────────────────────────────────────────────
autoload -Uz compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # Case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# ─────────────────────────────────────────────
#  zoxide (smarter cd)
# ─────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ─────────────────────────────────────────────
#  fzf
# ─────────────────────────────────────────────
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

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
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {}'"

# ─────────────────────────────────────────────
#  eza  (modern ls)
# ─────────────────────────────────────────────
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --color=always --group-directories-first --icons --git'
alias lt='eza --tree --color=always --icons --level=2'
alias la='eza -a --color=always --group-directories-first --icons'
alias l='eza -1 --color=always --icons'

# ─────────────────────────────────────────────
#  bat  (modern cat)
# ─────────────────────────────────────────────
alias cat='bat --style=auto'
alias catp='bat --plain'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# ─────────────────────────────────────────────
#  Git shortcuts
# ─────────────────────────────────────────────
alias g='git'
alias gs='git status -sb'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline --graph --decorate -20'
alias gla='git log --oneline --graph --decorate --all -30'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gpl='git pull'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'

# ─────────────────────────────────────────────
#  Navigation
# ─────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ─────────────────────────────────────────────
#  Utilities
# ─────────────────────────────────────────────
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -sh'
alias path='echo $PATH | tr ":" "\n"'
alias reload='source ~/.zshrc && echo "zshrc reloaded"'
alias zshconfig='${EDITOR:-code} ~/.zshrc'
alias cls='clear'
alias ip='curl -s ifconfig.me && echo'
alias localip='ipconfig getifaddr en0'
alias duh='du -sh * | sort -h'

# ─────────────────────────────────────────────
#  Editor
# ─────────────────────────────────────────────
export EDITOR='code'
export VISUAL='code'

# ─────────────────────────────────────────────
#  PATH
# ─────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────
#  NVM (Node Version Manager)
# ─────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
ZSHRC

success "~/.zshrc written"

# ── Step 9: Write ~/.p10k.zsh ─────────────────────────────────────────────────
step "9/9 — Applying recommended Powerlevel10k config"

# Only write p10k config if it doesn't already exist
if [[ -f "$HOME/.p10k.zsh" ]]; then
  warn "~/.p10k.zsh already exists — applying recommended tweaks only"

  # Apply the recommended settings via sed
  # 1. Two lines: add newline + prompt_char
  sed -i '' 's/POWERLEVEL9K_PROMPT_ADD_NEWLINE=false/POWERLEVEL9K_PROMPT_ADD_NEWLINE=true/' "$HOME/.p10k.zsh"

  # 2. Sharp heads (remove blurred start)
  sed -i '' "s/POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\\\\uE0BA'/POWERLEVEL9K_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''/" "$HOME/.p10k.zsh"
  sed -i '' "s/POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL='\\\\uE0BC'/POWERLEVEL9K_RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL=''/" "$HOME/.p10k.zsh"

  # 3. Flat tails (standard arrow instead of gradient)
  sed -i '' "s/POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='▓▒░'/POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL='\\\\uE0B0'/" "$HOME/.p10k.zsh"
  sed -i '' "s/POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='░▒▓'/POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL='\\\\uE0B2'/" "$HOME/.p10k.zsh"

  # 4. No frame
  sed -i '' "s/POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX='.*'/POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''/" "$HOME/.p10k.zsh"
  sed -i '' "s/POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX='.*'/POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=''/" "$HOME/.p10k.zsh"
  sed -i '' "s/POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX='.*'/POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''/" "$HOME/.p10k.zsh"
  sed -i '' "s/POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX='.*'/POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''/" "$HOME/.p10k.zsh"

  success "Powerlevel10k tweaks applied"
else
  warn "~/.p10k.zsh not found — you will configure it after running the wizard"
  warn "Run: p10k configure"
  warn "Use the recommended choices in README.md → Step 10"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo -e "${GREEN}${BOLD}  Setup complete!${RESET}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════${RESET}"
echo ""
echo -e "${BOLD}Remaining manual steps:${RESET}"
echo ""
echo -e "  ${YELLOW}1.${RESET} Open ${BOLD}iTerm2${RESET}"
echo -e "     Spotlight → Cmd+Space → type 'iTerm'"
echo ""
echo -e "  ${YELLOW}2.${RESET} Set the font in iTerm2:"
echo -e "     ${BOLD}Preferences → Profiles → Text → Font${RESET}"
echo -e "     Select: ${BOLD}MesloLGS Nerd Font${RESET}, size 14"
echo ""
echo -e "  ${YELLOW}3.${RESET} In the new iTerm2 window, run:"
echo -e "     ${BOLD}source ~/.zshrc${RESET}"
echo ""
echo -e "  ${YELLOW}4.${RESET} If this is a fresh install (no ~/.p10k.zsh), run:"
echo -e "     ${BOLD}p10k configure${RESET}"
echo -e "     Follow the recommended choices in ${BOLD}README.md → Step 10${RESET}"
echo ""
echo -e "  Full documentation: ${BOLD}~/terminal-setup/README.md${RESET}"
echo ""
