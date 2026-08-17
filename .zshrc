# -----------------------------------------------------------------------------
# Zinit stuffs
# -----------------------------------------------------------------------------

# Set the directory to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname "$ZINIT_HOME")"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Sourcing zinit
. "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k


# -----------------------------------------------------------------------------
# Exports
# -----------------------------------------------------------------------------

# Exporting binary directorys
SH_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}/shims"
LC_BIN="$HOME/.local/bin"

export PATH="$PATH:$SH_DIR:$LC_BIN"

# Append asdf-vm completions to fpath
fpath=($fpath ${ASDF_DATA_DIR:-$HOME/.asdf}/completions)


# -----------------------------------------------------------------------------
# Add in zsh plugins
# -----------------------------------------------------------------------------
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# -----------------------------------------------------------------------------
# Load completions
# -----------------------------------------------------------------------------
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# -----------------------------------------------------------------------------
# Keybindings
# -----------------------------------------------------------------------------
bindkey -e

bindkey '^p' history-search-backward	# Ctrl + p
bindkey '^n' history-search-forward		# Ctrl + n
bindkey '^[w' kill-region				# Ctrl + 

bindkey '^[[1;5C' forward-word          # Ctrl + right arrow
bindkey '^[[1;5D' backward-word         # Ctrl + left arrow

bindkey '^H' backward-kill-word         # Ctrl + Backspace
bindkey '^[[3;5~' kill-word             # Ctrl + Delete

bindkey '^[[1;5H' beginning-of-line     # Ctrl + Home
bindkey '^[[1;5F' end-of-line           # Ctrl + End

# -----------------------------------------------------------------------------
# History
# -----------------------------------------------------------------------------
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# -----------------------------------------------------------------------------
# Completion styling
# -----------------------------------------------------------------------------
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'


# -----------------------------------------------------------------------------
# Aliases
# -----------------------------------------------------------------------------

# General
#
alias ls='exa -la --icons'
alias cat='bat'
alias c='clear'
alias py='python'


# -----------------------------------------------------------------------------
# Shell integrations
# -----------------------------------------------------------------------------
eval "$(fzf --zsh)"

