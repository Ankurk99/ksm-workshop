# Install k3s
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik" sh -
KUBEDIR=$HOME/.kube
KUBECONFIG=$KUBEDIR/config
[[ ! -d $KUBEDIR ]] && mkdir $KUBEDIR
if [ -f $KUBECONFIG ]; then
    echo "Found $KUBECONFIG already in place ... backing it up to $KUBECONFIG.backup"
    cp $KUBECONFIG $KUBECONFIG.backup
fi
sudo cp /etc/rancher/k3s/k3s.yaml $KUBECONFIG
sudo chown $USER:$USER $KUBECONFIG
echo "export KUBECONFIG=$KUBECONFIG" | tee -a ~/.bashrc
kubectl get pods -A
kubectl wait --for=condition=Ready node --all --timeout=300s

# Install KubeArmor
helm repo add kubearmor https://kubearmor.github.io/charts
helm repo update kubearmor
helm upgrade --install kubearmor-operator kubearmor/kubearmor-operator -n kubearmor --create-namespace

# Install karmor-cli
curl -sfL http://get.kubearmor.io/ | sudo sh -s -- -b /usr/local/bin
