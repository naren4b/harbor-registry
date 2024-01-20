helm upgrade --install habor harbor/harbor \
              -f harbor-values.yaml \
              -n registry --create-namespace
