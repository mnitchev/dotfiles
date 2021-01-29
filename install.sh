#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

main() {
  generate_gitconfig
  compile_authorized_keys
  configure_home "$@"
}

generate_gitconfig() {
  if [[ -f "$HOME/.gitconfig" ]]; then
    return
  fi

  cat <<EOF >"$HOME/.gitconfig"
[include]
  path = ~/.common-gitconfig
[user]
  name = "Anonymous Eirininaut"
  email = "eirini@cloudfoundry.org"
[duet "env"]
  git-author-initials = ae
  git-author-name = Anonymous Eirininaut
  git-author-email = eirini@cloudfoundry.org
EOF
}

compile_authorized_keys() {
  local authorized_keys keys key
  authorized_keys="$HOME/.ssh/authorized_keys"

  while read -r gh_name; do
    keys=$(curl -sL "https://api.github.com/users/$gh_name/keys")
    if [[ "$keys" =~ "rate limit exceeded" ]]; then
      echo "+-------------------------------------------------------------------------+"
      echo "| ⚠️  WARNING:                                                             |"
      echo "+-------------------------------------------------------------------------+"
      echo "| Looks like we have exceeded the github rate limit. Skipping generation  |"
      echo "| of authorized_keys file. You will have to manually add authorized keys! |"
      echo "+-------------------------------------------------------------------------+"
      return
    fi
    key=$(jq -r ".[].key" <<<"$keys")
    echo "$key $gh_name" >>"$HOME/.ssh/authorized_keys"
  done <"$SCRIPT_DIR/team-github-ids"

  # remove duplicate keys
  sort --unique "$authorized_keys" -o "$authorized_keys"
}

configure_home() {
  local bundles action
  bundles=(nvim tmux zsh git-hooks git util cows)
  action=${1:-"install"}

  stow --dir="$SCRIPT_DIR" --target "$HOME" --delete "${bundles[@]}"
  if [[ "$action" == "clean" ]]; then
    return
  fi
  stow --dir="$SCRIPT_DIR" --target "$HOME" "${bundles[@]}"
}

main "$@"
