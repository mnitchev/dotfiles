# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""

plugins=(
  z
)

source $ZSH/oh-my-zsh.sh

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Git duet
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_GLOBAL=true

# Editors
export GIT_EDITOR="vim"
export KUBE_EDITOR="vim"

# Keys
bindkey '\C-b' beginning-of-line

# Vim stuff
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin

# Set Pure ZSH theme
autoload -U promptinit; promptinit
prompt pure

# Show non-zero exit status
precmd_pipestatus() {
    local exit_status="${(j.|.)pipestatus}"
    if [[ $exit_status = 0 ]]; then
           return 0
    fi
    echo -n ${exit_status}' '
}

prompt_pure_state=()
# Show exit code of last command as a separate prompt character
PROMPT='%(?.%F{magenta}.%F{red}❯%F{magenta})❯%f '
# Show exit status before prompt
PROMPT='%F{red}$(precmd_pipestatus)'$PROMPT

