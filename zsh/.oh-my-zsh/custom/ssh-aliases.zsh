alias fix-ssh='export-ssh-agent-config'
alias fixnload='fix-ssh && load-key'

export-ssh-agent-config() {
  eval "$(ssh-agent -s)"
}
