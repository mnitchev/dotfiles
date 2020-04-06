#!/bin/bash
set -xeuo pipefail

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
  name = "Anonymous Eirininaut"
  email = "eirini@cloudfoundry.org"
EOF
}

configure_home() {
  stow --dir="$SCRIPT_DIR" --target "$HOME" nvim tmux zsh git util
}

main
