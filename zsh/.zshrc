# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

ZSH_THEME="lambda-mod-zsh-theme/lambda-mod"
plugins=(
  docker
  docker-compose
  kubectl
  z
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Set language environment
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Git duet
export GIT_DUET_ROTATE_AUTHOR=1
export GIT_DUET_GLOBAL=true
export GIT_DUET_CO_AUTHORED_BY=1

# Editors
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export KUBE_EDITOR="nvim"


# Keys
bindkey '\C-b' beginning-of-line
bindkey "^[r" redo

# Vim stuff
export PATH=$PATH:$HOME/.gem/ruby/2.5.0/bin

# Custom scripts
export PATH=$HOME/bin:$PATH

# Kubectl Krew
export PATH="${PATH}:${HOME}/.krew/bin"

 #Golang
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

#pip
export PATH="$PATH:$HOME/.local/bin"

# snap
export PATH=$PATH:/snap/bin

# rust
source $HOME/.cargo/env

# Fuzzy Find
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 15% --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/"'

# Direnv
eval "$(direnv hook zsh)"

# Opsctl
source <(opsctl completion zsh)

# Fix forwarded sockets socket
if ! ssh-agent-socket-available; then
  fix-ssh
fi
