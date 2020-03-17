#    ___    ___
#   /   |  / (_)___ _________  _____
#  / /| | / / / __ `/ ___/ _ \/ ___/
# / ___ |/ / / /_/ (__  )  __(__  ) 
#/_/  |_/_/_/\__,_/____/\___/____/  

# Because bash...
alias watch='watch '

# ------------------ Git ------------------
alias g='git'
alias gc='git commit'
alias gcm='git commit -m'
alias gdc='git duet-commit'
alias gdcm='git commit -m'
alias gca='git commit --amend'

alias ga='git add'
alias gaup='git add -up'

alias gdiff='git diff'
alias gdiffc='git diff --cached'

alias gs='git status'

alias gba='git branch -a'
alias gco='git checkout'
alias gcob='git checkout -b'

alias gm='git merge'
alias greb='git rebase'
alias grebi='git rebase -i'

alias gsh='git show'

alias gres='git reset'
alias gresh='git reset HEAD'

alias gpush='git push'
alias gpull='git pull'
alias gfe='git fetch'

alias grem='git remote'
alias gremv='git remote -v'

alias glog='git log'
alias glog-fuller='git log --format=fuller'
alias glogtree='git logtree'

# ------------------ Kubernetes ------------------
alias k='kubectl'

alias kg='kubectl get'
alias kga='kubectl get all'
alias kgp='kubectl get pods'
alias kgd='kubectl get deployments'
alias kgst='kubectl get statefulsets'
alias kgds='kubectl get daemonsets'
alias kgser='kubectl get services'
alias kgj='kubectl get jobs'
alias kgn='kubectl get nodes'
alias kgsec='kubectl get secrets'
alias kgi='kubectl get ingresses'
alias kgns='kubectl get namespaces'
alias kgcm='kubectl get configmaps'
alias kgpvc='kubectl get pvc'
alias kgsa='kubectl get serviceaccount'
alias kgro='kubectl get role'
alias kgsc='kubectl get storageclass'

alias kdes='kubectl describe'
alias kdesp='kubectl describe pod'
alias kdesd='kubectl describe deployment'
alias kdesst='kubectl describe statefulset'
alias kdesser='kubectl describe service'
alias kdessec='kubectl describe secret'
alias kdesj='kubectl describe job'
alias kdesi='kubectl describe ingress'
alias kdesrs='kubectl describe replicaset'
alias kdessa='kubectl describe serviceaccount'
alias kdesro='kubectl describe role'

alias ke='kubectl edit'
alias kep='kubectl edit pod'
alias ked='kubectl edit deployment'
alias kest='kubectl edit statefulset'
alias keser='kubectl edit service'
alias kesec='kubectl edit secret'
alias kej='kubectl edit job'
alias kei='kubectl edit ingress'
alias kecm='kubectl edit configmap'
alias keds='kubectl edit daemonset'
alias kers='kubectl edit replicaset'
alias kero='kubectl edit role'

alias kdel='kubectl delete'
alias kdelp='kubectl delete pod'
alias kdeld='kubectl delete deployment'
alias kdelst='kubectl delete statefulset'
alias kdelser='kubectl delete service'
alias kdelj='kubectl delete job'
alias kdeli='kubectl delete ingress'
alias kdelrs='kubectl delete replicaset'
alias kdelsec='kubectl delete secret'

alias kpnuke='kube-nuke-pod'

alias ka='kubectl apply -f'
alias klo='kubectl logs -f'
alias kex='kube-exec'
alias kns='change-kube-namespace'


# ------------------ `General ------------------
alias klusters='kluster'
