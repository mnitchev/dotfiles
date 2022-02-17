#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

main() {
  configure_home "$@"
  generate_gitconfig
  prepare_coq_nvim
}

generate_gitconfig() {
  if [[ -f "$HOME/.gitconfig" ]]; then
    return
  fi

  cat <<EOF >"$HOME/.gitconfig"
[include]
  path = ~/.common-gitconfig
[user]
  name = "Mario Nitchev"
  email = "marionitchev@gmail.com"
[duet "env"]
  git-author-initials = mn
  git-author-name = Mario Nitchev
  git-author-email = marionitchev@gmail.com
EOF
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

prepare_coq_nvim() {
  nvim --headless "+COQdeps" "+COQsnips compile" "+qall"
}

main "$@"
