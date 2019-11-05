# Aliases
alias cd..="cd .."
alias gits="git status"
alias gitcm="git commit -m"
alias die="systemctl hibernate"
alias logtree="git logtree"
alias l="ls -la"
alias zconf="vim ~/.zshrc"
alias vimconf="vim ~/.vimrc"
alias tmux="TERM=screen-256color-bce tmux"

# Bindings
bindkey "^f" backward-word
bindkey "^b" forward-word
bindkey "^[a" beginning-of-line
bindkey "^[e" end-of-line

# Zsh themes
ZSH_THEME="lambda-mod/lambda-mod"

# Environment variables
export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/workspace/go"
export EIRINI="$GOPATH/src/code.cloudfoundry.org/eirini"
export JUNK="$HOME/workspace/junk"
export WORKSPACE="$HOME/workspace"
export UNISPACE="$HOME/unispace"
export KUBECONFIG="$(cat $HOME/.kubeconfigs)"
export KUBE_EDITOR="vim"
export KDEBUG=false
export GIT_DUET_GLOBAL=true
export GIT_DUET_ROTATE_AUTHOR=1
export LC_ALL=en_US.UTF-8

# Path configurations
#export PATH=$PATH:/usr/local/opt/go/libexec/bin
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$HOME/workspace/bin
export PATH="/usr/local/opt/unzip/bin:$PATH"

# Functions
genpass () {
  head /dev/urandom | uuencode -m - | sed -n 2p | cut -c1-${1:-8}
}

search(){
    what=$1
    dir=$2
    if [ -z $dir ]; then
        dir="."
    fi
    grep -rnw "$dir" -e "$what"
}

reload() {
    source $HOME/.zshrc
}

replace() {
    local keyword=${1?Keyword not present}
    local replacement=${2?Replacement not present}

    rg -l $keyword -g '!vendor/' | xargs -L 1 -o vim -c "%s/$keyword\C/$replacement/gc"
}

watch-dis() {
  local path=$1
  shift
  fswatch -0 $path | cmdrep $@
}

cmdrep() {
  local cmd="$@"
  while read -d "" event
  do
    eval $cmd
  done
}

export-certs() {
  SECRET=$(kubectl get pods --namespace uaa --output jsonpath='{.items[*].spec.containers[?(.name=="uaa")].env[?(.name=="INTERNAL_CA_CERT")].valueFrom.secretKeyRef.name}')
  CA_CERT="$(kubectl get secret "$SECRET" --namespace uaa --output jsonpath="{.data['internal-ca-cert']}" | base64 --decode -)"
  BITS_TLS_CRT="$(kubectl get secret "$(kubectl config current-context)" --namespace default -o jsonpath="{.data['tls\.crt']}" | base64 --decode -)"
  BITS_TLS_KEY="$(kubectl get secret "$(kubectl config current-context)" --namespace default -o jsonpath="{.data['tls\.key']}" | base64 --decode -)"
}

cf-lite() {
  local password="$1"
  local endpoint="$2"
  if [ -z $endpoint ]; then
    endpoint="https://api.$(cfwho).nip.io"
  fi
  cf api $endpoint --skip-ssl-validation
  cf login -o eirini -s dev -u admin -p "$password"
  cf create-org eirini
  cf target -o eirini
  cf create-space dev
  cf target -o eirini -s dev
}

## KUBERNETES
# GET STUFF BUT ALL OF THEM

wkpods() {
  kpods "$1" "w"
}

kpods() {
  kget "pods" "" "$1" "$2"
}

wksts() {
  kst "$1" "w"
}

ksts() {
  kget "statefulsets" "" "$1" "$2"
}

wksesr() {
  ksers "$1" "w"
}

ksers() {
  kget "services" "" "$1" "$2"
}

wksecs() {
  ksec "$1" "w"
}

ksecs() {
  kget "secrets" "" "$1" "$2"
}

wkconfs() {
  kconf "$1" "w"
}

kconfs() {
  kget "configmaps" "" "$1" "$2"
}

wkins() {
  kin "$1" "w"
}

kins() {
  kget "ingresses" "" "$1" "$2"
}

#GET STUFF BUT ONLY ONE
kpod() {
  local name=${1:?}
  kget "pod" "$name" "$2"
}

kst() {
  local name=${1:?}
  kget "statefulset" "$name" "$2"
}

kser() {
  local name=${1:?}
  kget "service" "$name" "$2"
}

ksec() {
  local name=${1:?}
  kget "secret" "$name" "$2"
}

kconf() {
  local name=${1:?}
  kget "configmap" "$name" "$2"
}

kin() {
  local name=${1:?}
  kget "ingress" "$name" "$2"
}

#DESCRIBE STUFF

kdpod() {
  local name=${1:?}
  kdes "pod" "$name" "$2"
}

kdst() {
  local name=${1:?}
  kdes "statefulset" "$name" "$2"
}

kdser() {
  local name=${1:?}
  kdes "service" "$name" "$2"
}

kdsec() {
  local name=${1:?}
  kdes "secret" "$name" "$2"
}

kdconf() {
  local name=${1:?}
  kdes "configmap" "$name" "$2"
}

kdin() {
  local name=${1:?}
  kdes "ingress" "$name" "$2"
}

#EDIT STUFF
kepod() {
  local name=${1:?}
  kedit "pod" "$name" "$2"
}

kedep() {
  local name=${1:?}
  kedit "deployment" "$name" "$2"
}

kest() {
  local name=${1:?}
  kedit "statefulset" "$name" "$2"
}

keser() {
  local name=${1:?}
  kedit "service" "$name" "$2"
}

kesec() {
  local name=${1:?}
  kedit "secret" "$name" "$2"
}

keconf() {
  local name=${1:?}
  kedit "configmap" "$name" "$2"
}

kein() {
  local name=${1:?}
  kedit "ingress" "$name" "$2"
}

kget() {
  kctl "get" "$1" "$2" "$3" "$4"
}

kgets() {
  kctl "get" "$1" "" "$2" "$3"
}

kdes() {
  kctl "describe" "$1" "$2" "$3" "$4"
}

kedit() {
  kctl "edit" "$1" "$2" "$3" "$4"
}

# MISC
knuke() {
  local namespace=$1
  kubectl delete namespace "$1"
  helm del --purge "$1"
}

kdel() {
  local resource=${1:?}
  local name=${2:?}
  local namespace=$3

  kctl "delete" "$resource" "$name" "$namespace" "" ""
}

kssh() {
  local pod="${1:?}"
  local namespace="$2"
  local container="$3"
  if [ "$namespace" = "-" ]; then
    namespace=""
  fi
  if ! [ -z $container ]; then
    pod="$pod --container $container"
  fi
  kctl "exec" "-it" "$pod" "$namespace" "" "/bin/bash"
}

alias klog=klogs

klogs() {
  local pod="${1:?}"
  local namespace="$2"
  local container="$3"
  local special="$4"
  if [ "$namespace" = "-" ]; then
    namespace=""
  fi
  if ! [ -z $container ]; then
    pod="$pod $container"
  fi
  kctl "logs" "" "$pod" "$namespace" "" "$special"
}

knames() {
  kget "namespaces" "" "" "$1"
}

knodes() {
#  kget "nodes" "" "" "$1"
  kubectl get nodes -o wide
}

kdnodes() {
  kdes "nodes" "" "" "$1"
}

kwho() {
 kubectl config current-context
}

kspace() {
  local namespace=${1:?}
  kubectl config set-context $(kubectl config current-context) --namespace="$namespace"
}

kspaces() {
  local watch="$1"
  kctl "get" "namespaces" "" "" "$watch" ""
}

kuse() {
  local cluster=${1:?}
  kubectl config use-context "$cluster"
}

kclusters(){
  kubectl config get-contexts
}

kadd() {
  local cluster=${1:?}
  local configpath
  configpath="$(bx cs cluster-config --export "$cluster" | grep -o "/Users.*\.yml")"
  if [ $? -ne 0 ]; then
    echo "Cluster: $cluster not found"
    return
  fi
  local currentconfs="$(cat $HOME/.kubeconfigs)"
  echo "Adding cluster: $cluster to known configs"
  echo "${currentconfs}:${configpath}" >"$HOME/.kubeconfigs"
  export KUBECONFIG="$(cat $HOME/.kubeconfigs)"
}

kdebug() {
  local flag=$1
  if [ -z $flag ]; then
    export KDEBUG=true
    return
  fi

  export KDEBUG=$flag
}

bclusters() {
  ibmcloud ks clusters
}

blogin(){
  ibmcloud login -a https://api.eu-gb.bluemix.net -u eirini@cloudfoundry.org -p "$(pass eirini/ibm-id)" -c "7e51fbb83371a0cb0fd553fab15aebf4"
}

cfwho(){
#  ksers scf | grep tcp-router-tcp-router-public | grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" | tail -n1
  kubectl get nodes -o wide | grep -E -o "158\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" | head -1
}

# HELP
kctl() {
  local verb="$1"
  local resource="$2"
  local name="$3"
  local namespace="$4"
  local watch="$5"
  local special="$6"
  local core="kubectl $verb $resource $name"
  local prefix
  local suffix

  if ! [ -z "$namespace" ]; then
    suffix="--namespace $namespace"
  fi
  if ! [ -z "$special" ]; then
    suffix="$suffix $special"
  fi
  if [ "$watch" = "w" ]; then
    prefix="watch"
  fi

  export KUBECONFIG="$(cat $HOME/.kubeconfigs)"
  kfunc $prefix $core $suffix
}

kfunc() {
  local prefix="$1"
  local core="$2"
  local suffix="$3"
  
  if $KDEBUG; then
    echo "Executing: $prefix $core $suffix"
  fi
  eval "$prefix $core $suffix"
}

# Misc
eval "$(direnv hook zsh)"
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh
source $HOME/.oh-my-zsh/plugins/z/z.sh
if [ $commands[kubectl] ]; then 
  source <(kubectl completion zsh); 
fi

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
)
ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

### Added by IBM Cloud CLI
#source /usr/local/Bluemix/bx
neofetch

# The next line updates PATH for the Google Cloud SDK.
if [ -f '$HOME/google-cloud-sdk/path.zsh.inc' ]; then . '$HOME/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]; then . '$HOME/google-cloud-sdk/completion.zsh.inc'; fi
