# Replicated preflight helm plugin

# This is a proof of concept do not use this at all under any circumstances :)

## requirements:

- have preflight binary built from this branch: https://github.com/danj-replicated/troubleshoot/tree/fetch in your $PATH
- have helm installed
- your preflight.yaml must be at the root level of your helm chart

## install

```bash
helm plugin install https://github.com/danj-replicated/helm-preflight

```

## usage

```bash
helm preflight oci://registry.replicated.com/app appname
```

## TODO

Add an `--apply` flag to apply chart if preflights pass