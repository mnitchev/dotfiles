alias fix-ssh='ssh-agent-socket-available || export-ssh-agent-config'
alias fixnload='fix-ssh && load-key'
alias pssh='print-ssh-command'

export-ssh-agent-config() {
  killall ssh-agent 2>/dev/null
  local ssh_sock
  for dir in $(ls /tmp | grep ssh); do 
    sock="$(ls /tmp/$dir)"
    ssh_sock="/tmp/$dir/$sock"
    if test -S "$ssh_sock"; then
      export SSH_AUTH_SOCK="$ssh_sock"
    fi
  done
}

ssh-agent-socket-available() {
  test -S "$SSH_AUTH_SOCK"
}

print-ssh-command() {
  username=$(whoami)
  ip=$(curl -s ipecho.net/plain)
  echo "ssh -R $HOME/.gnupg/S.gpg-agent-guest:\$(gpgconf --list-dirs agent-socket) ${username}@${ip}"
}
