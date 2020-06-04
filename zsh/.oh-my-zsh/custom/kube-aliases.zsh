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
alias kuse='change-kube-cluster'
alias kssh='kube-ssh'

kube-ssh() {
    local name line_num pod_name namespace results_count pod_metadata
    name=$1
    line_num=1
    shift 1
    pod_metadata=$(kgp --all-namespaces -o custom-columns=:.metadata.name,:.metadata.namespace | awk -v name="$name" '$1 ~ name { print }')
    results_count="$(echo $pod_metadata | wc -l)"
    if [[ -z "$pod_metadata" ]]; then
        echo "No pod found that matches name $name"
        return 1
    fi
    if [[ "$results_count" -gt 1 ]]; then
      local count=1
      echo "Found $results_count pods:"
      for i in $(seq 1 $results_count); do
          echo "${count}) $(echo $pod_metadata | sed -n "${i}p")"
          count=$((count+1))
      done
      while true; do
      read "line_num?Select pod number: "
      if [[ "$line_num" -gt 0 ]] && [[ "$line_num" -le "$results_count" ]]; then
        break
      fi
      done
      pod_metadata="$(echo $pod_metadata | sed -n "${line_num}p")"
    fi
    pod_name="$(echo $pod_metadata | awk '{ print $1 }')"
    namespace="$(echo $pod_metadata | awk '{ print $2 }')"
    kube-exec $pod_name -n $namespace $@
}

# attach to a pod
kube-exec() {
    kubectl exec "$@" -it /bin/bash
    if [[ "$?" -eq 1 ]]; then
        kubectl exec "$@" -it /bin/sh
    fi
}

# set namespace
change-kube-namespace() {
    local ns
    ns="$1"
    if [[ -z "$ns" ]];then
        #TODO: print current namespace
    fi
    local ctx
    ctx=$(kubectl config current-context)

    ns=$(kubectl get namespace $1 --no-headers --output=go-template={{.metadata.name}} 2>/dev/null)

    if [ -z "${ns}" ]; then
        echo "Namespace (${1}) not found!"
        return 1
    fi

    kubectl config set-context ${ctx} --namespace="${ns}"
}

change-kube-cluster() {
    local name cluster_name
    name="$1"
    cluster_name="$(kubectl config get-clusters | grep "$name")"
    kubectl config use-context "$cluster_name"
}
