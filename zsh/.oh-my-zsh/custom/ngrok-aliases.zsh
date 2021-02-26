alias pssh='print-ssh-command'
alias pattach='tmux attach -t pairing'
alias pmux='tmux new-session -s pairing'
alias lsgrok='print-ngrok-tunnel'
alias nginit='init-ngrok'

bold="\033[1m"
normal="\033[0m"
yellow="\033[33m"

print-ssh-command() {
  username=$(whoami)
  connection="$(get-ngrok-host)"
  if [[ "$?" -ne 0 ]]; then
    ip=$(curl -s ipecho.net/plain)
    connection="$username@$ip"
  fi

  echo "${bold}${yellow}Using plain ssh:${normal}"
  echo
  echo "ssh $username@$ip"
  echo
  echo "${bold}${yellow}Or using pair-connect:${normal}"
  echo
  echo "pair-connect $connection"
}

print-ngrok-tunnel() {
  echo "ssh $(get-ngrok-host)"
}

get-ngrok-host() {
url=$(curl http://localhost:4040/api/tunnels 2>/dev/null | jq -r '.tunnels[0].public_url')

if [[ "$url" == "" ]] || [[ "$url" == "null" ]]; then
  echo "No tunnels running?"
  return 1
else
  host="$(echo "$url" | cut -d / -f 3 | cut -d : -f 1)"
  port="$(echo "$url" | cut -d / -f 3 | cut -d : -f 2)"

  echo "$(whoami)@$host -p $port"
fi
}

init-ngrok() {
  tmux new-session -s ngrok -d
  tmux send -t ngrok "ngrok tcp --region=eu 22" ENTER
}
