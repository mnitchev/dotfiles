alias fix-gpg='symlink-gpg-agent-socket'
alias use-gpg='symlink-gpg-agent-socket-interactive'
alias who-gpg='get-active-gpg-socket'
alias pass='echo 1>&2 GPG: using the $(who-gpg) socket && pass'

gpg-socket-symlinked() {
  local system_gpg_socket_location
  system_gpg_socket_location="$(gpgconf --list-dir agent-socket)"

  test -L "$system_gpg_socket_location"
}

symlink-gpg-agent-socket() {
  local system_gpg_socket_location user
  user="${1:-host}"

  system_gpg_socket_location="$(gpgconf --list-dir agent-socket)"
  rm -f "$system_gpg_socket_location"
  ln -s "${HOME}/.gnupg/S.gpg-agent-$user" "$system_gpg_socket_location"
}

symlink-gpg-agent-socket-interactive() {
  local prefix user
  prefix="S.gpg-agent-"

  user=$(ls -1 "$HOME/.gnupg" | grep "$prefix" | sed -e "s/^$prefix//" | fzf)
  symlink-gpg-agent-socket "$user"
}

get-active-gpg-socket() {
  basename $(readlink $(gpgconf --list-dirs agent-socket)) | sed -e "s/^S.gpg-agent-//"
}
