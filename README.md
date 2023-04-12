# Replicated preflight helm plugin

# This is a proof of concept do not use this at all under any circumstances :)

## requirements:

- have preflight binary built from this branch: https://github.com/danj-replicated/troubleshoot/tree/preflight-stdin
- have helm installed
- your preflight.yaml must be at the root level of your helm chart
- have helm installed

## install

temporary install instructions while because the repo is private

```bash
git clone git@github.com:danj-replicated/helm-preflight.git
cd helm-preflight
helm plugin install .

```

## usage

```bash
helm preflight oci://some.registry/chart

helm preflight ./chart
```