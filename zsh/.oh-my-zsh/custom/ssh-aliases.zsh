alias fix-ssh='export-ssh-agent-config'
alias fixnload='fix-ssh && load-key'
alias pssh='print-ssh-command'

export-ssh-agent-config() {
  killall ssh-agent 2>/dev/null
  local ssh_sock
  ssh_sock="$XDG_RUNTIME_DIR/keyring/.ssh"
  if [[ -z "$ssh_sock" ]]; then
      eval "$(ssh-agent -s)"
      return
  fi
  export SSH_AUTH_SOCK="$ssh_sock"
}

ssh-agent-socket-available() {
  test -S "$SSH_AUTH_SOCK"
}

print-ssh-command() {
  username=$(whoami)
  ip=$(curl -s ipecho.net/plain)
  echo "ssh -A -R $HOME/.gnupg/S.gpg-agent-guest:\$(gpgconf --list-dirs agent-socket) ${username}@${ip}"
}
