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
alias amp="npx @sourcegraph/amp"

# autocomplete
autoload -U compinit
compinit -C

eval "$(starship init zsh)"
