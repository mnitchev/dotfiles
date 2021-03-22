#    ___    ___
#   /   |  / (_)___ _________  _____
#  / /| | / / / __ `/ ___/ _ \/ ___/
# / ___ |/ / / /_/ (__  )  __(__  )
#/_/  |_/_/_/\__,_/____/\___/____/

alias c='clear'
alias watch='watch '
alias vim='nvim'
alias cflogin='cf-lite'
alias dockerlogin='docker login -u eiriniuser -p $(pass eirini/docker-hub)'
alias flylogin='fly-login'
alias flake-hunter='concourse-flake-hunter -c https://jetson.eirini.cf-app.com -n main search'
alias eirinisay='cowsay -f $HOME/cows/eirini.cow'

cf-lite() {
  local context_name cluster_name
  pull_if_needed "$HOME/workspace/eirini-private-config"
  context_name="$(kubectl config current-context)"
  if [[ $context_name =~ gke ]]; then
      cluster_name="$(echo "$context_name" | sed "s/gke_cff-eirini-peace-pods_europe-west[1-9]-[a-z]_//g")"
      cf_login_gke "$cluster_name"
  elif [[ $context_name =~ kind- ]]; then
      cluster_name="$(echo "$context_name" | sed "s/^kind-//")"
      cf_login_kind "$cluster_name"
  else
      cluster_name="$(echo "$context_name" | sed "s/\/.*$//g")"
      cf_login_ibmcloud "$cluster_name"
  fi
}

pull_if_needed() {
  local git_dir
  git_dir="$1"
  git -C "$git_dir" fetch --all
  if $(git -C "$git_dir" st -uno  | grep -q behind); then
    git -C "$git_dir" pull --rebase
  fi
}

cf_login_ibmcloud() {
    local cluster_name endpoint_path password_path
    cluster_name="$1"
    values_file="$HOME/workspace/eirini-private-config/environments/kube-clusters/$cluster_name/values.yaml"
    endpoint_path="env.DOMAIN"
    password_path="secrets.CLUSTER_ADMIN_PASSWORD"
    cf_login "$cluster_name" "$values_file" "$endpoint_path" "$password_path"
}

cf_login_gke() {
    local cluster_name endpoint_path password_path
    cluster_name="$1"
    values_file="$HOME/workspace/eirini-private-config/environments/kube-clusters/$cluster_name/default-values.yml"
    endpoint_path="system_domain"
    password_path="cf_admin_password"
    cf_login "$cluster_name" "$values_file" "$endpoint_path" "$password_path"
}

cf_login_kind() {
    local cluster_name endpoint_path password_path
    cluster_name="$1"
    values_file="$HOME/workspace/eirini/scripts/values/$cluster_name.cf-values.yml"
    endpoint_path="system_domain"
    password_path="cf_admin_password"
    cf_login "$cluster_name" "$values_file" "$endpoint_path" "$password_path"
}

cf_login() {
  local cluster_name endpoint_path password_path endpoint password
  cluster_name="$1"
  values_file="$2"
  endpoint_path="$3"
  password_path="$4"
  endpoint="api.$(yq eval ".$endpoint_path" "$values_file")"
  password="$(yq eval ".$password_path" "$values_file")"

  echo "Loging into cluster $cluster_name"
  cf api $endpoint --skip-ssl-validation || return
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
  fly --target eirini logout
  fly --target eirini login --team-name "$team" --concourse-url https://jetson.eirini.cf-app.com/
}
