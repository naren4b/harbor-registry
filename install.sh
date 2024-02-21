# Install harbor
helm upgrade --install harbor harbor/harbor \
    -f harbor-values.yaml \
    -n registry --create-namespace
