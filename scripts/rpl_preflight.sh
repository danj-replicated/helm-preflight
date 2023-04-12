#!/bin/bash

render_dir=$(mktemp -d)
pull_dir="$(mktemp -d)"

cleanup () {
  rm -r "${render_dir}"
  rm -r "${pull_dir}"
}

# extract helm archive
case "$1" in
  *://*)
    # if our chart location looks like a url, pull and extract it
    helm pull -d "${pull_dir}" --untar --untardir "${render_dir}" "$1"
    ;;
  *)
    # otherwise just try and extract it
    tar -C ${render_dir} -xvf $1
    ;;
esac

# inject preflight.yaml into templates and render
# piping into preflight for actual checks
while read chart ; do
  cp "${render_dir}/$chart/preflight.yaml" "${render_dir}/$chart/templates"
  ${HELM_BIN} template "${render_dir}/$chart" | preflight -
done < <(ls "${render_dir}")

cleanup