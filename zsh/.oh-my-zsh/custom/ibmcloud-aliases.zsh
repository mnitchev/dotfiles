alias ibmlogin='ibmcloud login -u eirini@cloudfoundry.org -p $(pass eirini/ibm-id)'
alias ibmcluster='replace-ibm-cluster'

replace-ibm-cluster() {
    local name old_name
    name="$1"
    if old_name="$(kubectl config get-clusters | grep "$name")"; then
        kubectl config delete-cluster "$old_name"
    fi
    ibmcloud ks cluster config --cluster "$name"
}
