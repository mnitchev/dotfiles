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
export GIT_EDITOR="nvim"
export KUBE_EDITOR="nvim"

# Keys
bindkey '\C-b' beginning-of-line

# Vim stuff
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin

# Custom scripts
export PATH=$PATH:$HOME/bin

# Set Pure ZSH theme
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure
zstyle :prompt:pure:path color '#6871FF'
