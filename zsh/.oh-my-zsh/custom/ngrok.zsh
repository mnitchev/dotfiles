alias pattach='tmux attach -t pairing'
alias pmux='tmux new-session -s pairing'
alias ngattach='tmux attach -t ngrok'

function nginit {
  tmux new-session -s ngrok -d "ngrok tcp --region=eu 22"
}

function lsgrok {
url=$(curl http://localhost:4040/api/tunnels 2>/dev/null | jq -r '.tunnels[0].public_url')

if [[ "$url" == "" ]] || [[ "$url" == "null" ]]; then
  echo "No tunnels running?"
else
  host="$(echo "$url" | cut -d / -f 3 | cut -d : -f 1)"
  port="$(echo "$url" | cut -d / -f 3 | cut -d : -f 2)"

  echo "ssh -p $port $(whoami)@$host"
fi
}

