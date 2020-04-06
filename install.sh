#!/bin/bash
set -xeuo pipefail

NAME=${NAME:-"Anonymous Eirininaut"}
EMAIL=${EMAIL:-"eirini@cloudfoundry.org"}
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

main() {
  generate_gitconfig
  configure_home
}

generate_gitconfig() {
  cat <<EOF > "$HOME/.gitconfig"
[include]
  path = ~/.common-gitconfig
[user]
  name = $NAME
  email = $EMAIL
EOF
}

configure_home() {
  stow --dir="$SCRIPT_DIR" --target "$HOME" nvim tmux zsh git
}

main
