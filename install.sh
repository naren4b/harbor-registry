# Install Ingrss controller
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
kubectl label nodes controlplane ingress-ready="true"
kubectl apply -f deploy.yaml

# Install harbor
helm upgrade --install habor harbor/harbor \
    -f harbor-values.yaml \
    -n registry --create-namespace
