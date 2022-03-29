alias pattach='tmux attach -t pairing'
alias pmux='tmux new-session -s pairing'
alias lsgrok='print-ngrok-tunnel'
alias nginit='init-ngrok'

print-ngrok-tunnel() {
url=$(curl http://localhost:4040/api/tunnels 2>/dev/null | jq -r '.tunnels[0].public_url')

if [[ "$url" == "" ]] || [[ "$url" == "null" ]]; then
  echo "No tunnels running?"
else
  host="$(echo "$url" | cut -d / -f 3 | cut -d : -f 1)"
  port="$(echo "$url" | cut -d / -f 3 | cut -d : -f 2)"

  echo "ssh -A -p $port $(whoami)@$host"
fi
}

init-ngrok() {
  tmux new-session -s ngrok -d
  tmux send -t ngrok "ngrok tcp --region=eu 22" ENTER
}

