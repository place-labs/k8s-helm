# Install
helm install metrics . -f values.yaml -n placeos-metrics --create-namespace

# Upgrade
helm upgrade --install metrics . -f values.yaml -n placeos-metrics --create-namespace

