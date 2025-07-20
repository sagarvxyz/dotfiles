export PROJECTS=~/code

if [[ -a ~/.zshenv ]]; then
	source ~/.zshenv
fi

if [[ -a ~/.localrc ]]; then
	source ~/.localrc
fi

# PATH configuration (loaded first)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="./bin:/usr/local/bin:/usr/local/sbin:$PATH"
export PATH="$PATH:/Users/svelagala/.local/bin"

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Aliases
alias gl='git pull --prune'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status -sb'
alias gac='git add -A && git commit -m'
alias gz='git undo'
alias gbp="git branch-prune"

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
compinit

# Git completion
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi
