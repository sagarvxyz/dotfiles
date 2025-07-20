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

# NVM configuration (lazy-loaded for performance)
export NVM_DIR="$HOME/.nvm"
nvm() {
    unset -f nvm node npm npx
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    nvm "$@"
}
node() { nvm; node "$@"; }
npm() { nvm; npm "$@"; }
npx() { nvm; npx "$@"; }

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
alias reload="source ~/.zshrc"

#amp code init
alias amp="npx @sourcegraph/amp"

# initialize autocomplete here, otherwise functions won't be loaded
autoload -U compinit
# Only regenerate compdump if it's older than 24 hours for performance
if [[ $HOME/.zcompdump(#qNmh+24) ]]; then
    compinit -C  # Skip security check
else
    compinit
fi

# Git completion
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi
