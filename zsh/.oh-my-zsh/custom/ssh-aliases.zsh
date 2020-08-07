alias fix-ssh='export-ssh-agent-config'
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
