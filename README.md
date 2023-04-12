# Replicated preflight helm plugin

# This is a proof of concept do not use this at all under any circumstances :)

## requirements:

- have preflight binary built from this branch: https://github.com/danj-replicated/troubleshoot/tree/fetch in your $PATH
- you must have a helm-chart release in replicated vendor portal
- have helm installed

## install

```bash
helm plugin install https://github.com/danj-replicated/helm-preflight

```

## usage

```bash
helm preflight oci://registry.replicated.com/app-slug chart-name
```

## TODO

Add an `--apply` flag to apply chart if preflights pass