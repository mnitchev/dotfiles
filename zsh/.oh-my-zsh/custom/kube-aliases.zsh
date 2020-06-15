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
alias kssh='kube-ctl kube-exec pod'
alias klogs='kube-ctl kube-logs pod'
alias kedit='kube-ctl kube-edit'
alias kdes='kube-ctl kube-des'

kube-edit() {
  kubectl edit $@
}

kube-des() {
  kubectl describe $@
}

kube-logs() {
  shift 1
  exec 3>&1
  err=$(kubectl logs -f $@ 2>&1 1>&3)
  if [[ "$?" -eq 1 ]] && $(echo -n "$err" | grep -q "a container name must be specified"); then
      local count=1 line_num result_count containers
      containers=$(echo -n "$err" | awk -F '[][]' '{print $2}')
      result_count=$(echo -n $containers | wc -w)

      echo "Found $result_count containers:"
      for i in $(seq 1 $result_count); do
          echo "${count}) $(echo -n $containers | awk -v N=$i '{print $N}')"
          count=$((count+1))
      done
      while true; do
      read "line_num?Select pod number: "
      if [[ "$line_num" -gt 0 ]] && [[ "$line_num" -le "$result_count" ]]; then
        break
      fi
      done
      container="$(echo -n $containers | awk -v N=$line_num '{print $N}')"
      kubectl logs -f $@ -c "$container"
  fi
}

kube-ctl() {
    local command_name resource_type name line_num resource_name namespace result_count resource_metadata
    command_name="$1"
    resource_type="$2"
    name="$3"
    line_num=1
    shift 3
    resource_metadata=$(kubectl get "$resource_type" --all-namespaces -o custom-columns=:.metadata.name,:.metadata.namespace | awk -v name="$name" '$1 ~ name { print }')
    result_count="$(echo $resource_metadata | wc -l)"
    if [[ -z "$resource_metadata" ]]; then
        echo "No resource $resource_type found that matches name $name"
        return 1
    fi
    if [[ "$result_count" -gt 1 ]]; then
      local count=1
      echo "Found $result_count ${resource_type}s:"
      for i in $(seq 1 $result_count); do
          echo "${count}) $(echo $resource_metadata | sed -n "${i}p")"
          count=$((count+1))
      done
      while true; do
      read "line_num?Select pod number: "
      if [[ "$line_num" -gt 0 ]] && [[ "$line_num" -le "$result_count" ]]; then
        break
      fi
      done
      resource_metadata="$(echo $resource_metadata | sed -n "${line_num}p")"
    fi
    resource_name="$(echo $resource_metadata | awk '{ print $1 }')"
    namespace="$(echo $resource_metadata | awk '{ print $2 }')"
    $command_name $resource_type $resource_name -n $namespace $@
}

# attach to a pod
kube-exec() {
    shift 1
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
