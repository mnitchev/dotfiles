alias fix-ssh='export-ssh-agent-config'
alias fix-gpg='symlink-gpg-agent-socket'
alias fix-user='fix-ssh && fix-gpg'
alias fixnload='fix-ssh && load-key'

export-ssh-agent-config() {
  killall ssh-agent 2>/dev/null
  local ssh_sock
  ssh_sock="$(ls -dt /tmp/ssh*/* | head -1)"
  if [[ -z "$ssh_sock" ]]; then
      eval "$(ssh-agent -s)"
      return
  fi
  export SSH_AUTH_SOCK="$ssh_sock"
}

symlink-gpg-agent-socket() {
  local system_gpg_socket_location user
  user="$1"
  if [[ -z "$user" ]]; then
    user="$(whoami)"
  fi
  system_gpg_socket_location="$(gpgconf --list-dir agent-socket)"
  rm -f "$system_gpg_socket_location"
  ln -s "${HOME}/.gnupg/S.gpg-agent-$user" "$system_gpg_socket_location"
}
