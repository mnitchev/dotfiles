alias ibmlogin='ibm-login'
alias ibmcluster='replace-ibm-cluster'

ibm-login() {
  # Log into the Bluemix Flintstone account via the -c parameter
  ibmcloud login -u eirini@cloudfoundry.org -p $(pass eirini/ibm-id) -c "7e51fbb83371a0cb0fd553fab15aebf4" --no-region
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
