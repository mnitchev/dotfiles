function fix-ssh {
  eval "$(ssh-agent -s)"
}

function add-key {
  gh-auth add --users "$@" --command="$(command -v which tmux) attach -t pairing"
}
