#    ___    ___
#   /   |  / (_)___ _________  _____
#  / /| | / / / __ `/ ___/ _ \/ ___/
# / ___ |/ / / /_/ (__  )  __(__  )
#/_/  |_/_/_/\__,_/____/\___/____/

alias c='clear'
alias watch='watch '
alias vim='nvim'
alias pbcopy='xsel --clipboard --input'
alias pbpaste='xsel --clipboard --output'
alias cflogin='cf-lite'
alias dockerlogin='docker login -u eiriniuser -p $(pass eirini/docker-hub)'
alias flylogin='fly-login'

cf-lite() {
  local password="$1"
  local endpoint="$2"
  if [ -z $endpoint ]; then
    endpoint="https://api.$(cf-ip).nip.io"
  fi
  cf api $endpoint --skip-ssl-validation
  if ! cf login -u admin -p "$password" -o o -s s; then
    cf create-org o
    cf target -o o
    cf create-space s
    cf target -o o -s s
  fi
}

cf-ip() {
  kubectl get nodes -ojsonpath="{ .items[0].metadata.labels['ibm-cloud\.kubernetes\.io/external-ip'] }"
}

fly-login() {
  local team
  team=${1:-"main"}
  fly --target eirini login --team-name "$team" --concourse-url https://jetson.eirini.cf-app.com/
}
