#!/bin/bash

render_dir="$(mktemp -d)"
pull_dir="$(mktemp -d)"

cleanup () {
  rm -r "${render_dir}"
  rm -r "${pull_dir}"
}

# extract helm archive
case "$1" in
  oci://*)
    printf "%s\n" "Pulling chart..."
    # don't know how to discover the chart name yet so we just have an arg for it
    chartname=$2
    # if our chart location looks like a url, pull and extract it
    helm pull -d "${pull_dir}" --untar --untardir "${render_dir}" "$1/$chartname"
    ;;
  *)
    # do nothing if not oci, since this is replicated specific
    exit 1
  ;;
esac

# inject preflight.yaml into templates and render
# piping into preflight for actual checks
while read chart ; do
  preflight fetch "$1" > "${render_dir}/${chart}/templates/preflight.yaml"
  ${HELM_BIN} template "${render_dir}/$chart" | preflight -
done < <(ls "${render_dir}")

cleanup