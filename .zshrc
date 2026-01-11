# Source additional configuration files
[ -f "$HOME/.zshenv" ] && . "$HOME/.zshenv"
[ -f "$HOME/.localrc" ] && . "$HOME/.localrc"

# PATH configuration
export PATH="/opt/homebrew/bin:$PATH"
export PATH="./bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$PATH:/Users/svelagala/.local/bin"

# Set PATH for GUI applications on login
launchctl setenv PATH "$PATH"

# Enable vim bindings in zsh
bindkey -v
# Fix backspace in insert mode
bindkey "^?" backward-delete-char

# Global Aliases
alias gbp="git branch-prune"
alias reload="source ~/.zshrc"

# direnv - directory-specific environment variables (silent)
export DIRENV_LOG_FORMAT=""
eval "$(direnv hook zsh)"

# chpwd - directory-specific aliases
_load_dir_aliases() {
  unset -f $(typeset +f | grep '^_alias_' 2>/dev/null) 2>/dev/null
  
  if [[ "$PWD" == "$HOME/code"* ]] && [[ -f "$HOME/code/.aliases" ]]; then
    source "$HOME/code/.aliases"
  elif [[ "$PWD" == "$HOME/netflix"* ]] && [[ -f "$HOME/netflix/.aliases" ]]; then
    source "$HOME/netflix/.aliases"
  fi
}
autoload -U add-zsh-hook
add-zsh-hook chpwd _load_dir_aliases
_load_dir_aliases

# autocomplete
autoload -U compinit
compinit -C

eval "$(starship init zsh)"

# Amp CLI
export PATH="/Users/sagarv/.amp/bin:$PATH"
