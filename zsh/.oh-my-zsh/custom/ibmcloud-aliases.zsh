alias ibmlogin='ibm-login'
alias ibmcluster='replace-ibm-cluster'

ibm-login() {
  ibmcloud login -u eirini@cloudfoundry.org -p $(pass eirini/ibm-id)
  eirinisay  "IMPORTANT NOTICE: Please DO NOT delete ibm clusters \"pebbles01\" and \"dino02\" as they are owned by the Quarks Team" | lolcat -as 200
}

replace-ibm-cluster() {
    local name old_name
    name="$1"
    if old_name="$(kubectl config get-clusters | grep "$name")"; then
        kubectl config delete-cluster "$old_name"
    fi
    IKS_BETA_VERSION=1 ibmcloud ks cluster config --cluster "$name"
}
