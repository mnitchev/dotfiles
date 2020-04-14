# Path to oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

ZSH_THEME=""

plugins=(
  z
  zsh-autosuggestions
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

# Show non-zero exit status
precmd_pipestatus() {
    local exit_status="${(j.|.)pipestatus}"
    if [[ $exit_status = 0 ]]; then
           return 0
    fi
    echo -n ${exit_status}' '
}

# Set Pure ZSH theme
fpath+=$HOME/.zsh/pure
autoload -U promptinit; promptinit
prompt pure

# Remove pure theme state (user@hostname) from prompt
prompt_pure_state=()

# Show current pair
precmd_git_duet() {
    local author author_initials committer committer_initials
    author="$(git duet | grep AUTHOR_NAME | cut -d "=" -f 2| tr -d \')"
    author_initials="$(grep "$author" ~/.git-authors | cut -d ":" -f 1 | sed 's/ //g')"

    committer="$(git duet | grep COMMITTER_NAME | cut -d "=" -f 2| tr -d \')"
    committer_initials="$(grep "$committer" ~/.git-authors | cut -d ":" -f 1 | sed 's/ //g')"

    if [ "$author_initials" = "$committer_initials" ]; then
        RPROMPT="solo~$author_initials"
        return 0
    fi
    RPROMPT="pair~$author_initials+$committer_initials"
}
add-zsh-hook precmd precmd_git_duet

# Show current kubectl cluster and namespace
precmd_kubectl_context() {
    local context
    if ! context="$(kubectl config current-context 2>/dev/null)"; then
        # ZSH_KUBECTL_PROMPT=""
        return 1
    fi
    local ns kube_symbol kubectl_prompt tidy_context
    ns="$(kubectl config view -o "jsonpath={.contexts[?(@.name==\"${context}\")].context.namespace}")"
    tidy_context="$(kubectl config current-context | cut -d "/" -f 1 2>/dev/null)"

    kube_symbol='k8s'
    kubectl_prompt="${kube_symbol}~${tidy_context}:${ns}"

    RPROMPT="${kubectl_prompt} | "$RPROMPT
}
add-zsh-hook precmd precmd_kubectl_context

# Surround RPROMPT
precmd_surround_rprompt() {
  RPROMPT="%{$fg[blue]%}«${RPROMPT}»%{$reset_color%}"
}
add-zsh-hook precmd precmd_surround_rprompt



# Show exit code of last command as a separate prompt character
PROMPT='%(?.%F{#32CD32}.%F{red}❯%F{red})❯%f '

# Show exit status before prompt
PROMPT='%F{red}$(precmd_pipestatus)'$PROMPT

# Fuzzy Find
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 15% --border'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*" --glob "!vendor/"'

# Direnv
eval "$(direnv hook zsh)"

# kubectl completion
source <(kubectl completion zsh)
