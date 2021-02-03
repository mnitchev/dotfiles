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
  ip=$(curl -s ipecho.net/plain)
  echo "${bold}${yellow}Using plain ssh:${normal}"
  echo
  echo "ssh -A -R /home/$username/.gnupg/S.gpg-agent-\$EIRINI_STATION_USERNAME:\$HOME/.gnupg/S.gpg-agent.extra $username@$ip"
  echo
  echo "${bold}${yellow}Or using pair-connect:${normal}"
  echo
  echo "pair-connect -a $username@$ip"
}

print-ngrok-tunnel() {
url=$(curl http://localhost:4040/api/tunnels 2>/dev/null | jq -r '.tunnels[0].public_url')

if [[ "$url" == "" ]] || [[ "$url" == "null" ]]; then
  echo "No tunnels running?"
else
  host="$(echo "$url" | cut -d / -f 3 | cut -d : -f 1)"
  port="$(echo "$url" | cut -d / -f 3 | cut -d : -f 2)"

  echo "ssh -p $port $(whoami)@$host"
fi
}

init-ngrok() {
  tmux new-session -s ngrok -d
  tmux send -t ngrok "ngrok tcp --region=eu 22" ENTER
}
