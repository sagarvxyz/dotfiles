export PROJECTS=~/code

if [[ -a ~/.zshenv ]]; then
	source ~/.zshenv
fi

if [[ -a ~/.localrc ]]; then
	source ~/.localrc
fi

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

# Git completion
completion='$(brew --prefix)/share/zsh/site-functions/_git'

if test -f $completion
then
  source $completion
fi

# Prompt
autoload -Uz vcs_info
precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats '(@%r/%b)'
zstyle ':vcs_info:*' enable git

setopt PROMPT_SUBST
PROMPT='%D{%y/%m/%d %H:%M:%S} ${vcs_info_msg_0_:-(%m)} %(3~|../%2~|%~) %# '
