# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="spaceship"

plugins=(
  z
)

source $ZSH/oh-my-zsh.sh

# Set language environment
export LANG=en_US.UTF-8

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
