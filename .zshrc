export PROJECTS=~/code

# Source additional configuration files
[ -f "$HOME/.zshenv" ] && . "$HOME/.zshenv"
[ -f "$HOME/.localrc" ] && . "$HOME/.localrc"

# PATH configuration  
export PATH="/opt/homebrew/bin:$PATH"
export PATH="./bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$PATH:/Users/svelagala/.local/bin"

# mise-en-place
eval "$(mise activate zsh)"

# Enable vim bindings in zsh
bindkey -v
# Fix backspace in insert mode
bindkey "^?" backward-delete-char

# Aliases
alias gbp="git branch-prune"
alias reload="source ~/.zshrc"

# autocomplete
autoload -U compinit
compinit -C

# Prompt
autoload -Uz vcs_info
precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats '(@%r/%b)'
zstyle ':vcs_info:*' enable git

setopt PROMPT_SUBST
PROMPT='%D{%y/%m/%d %H:%M:%S} ${vcs_info_msg_0_:-(%m)} %(3~|../%2~|%~) %# '
