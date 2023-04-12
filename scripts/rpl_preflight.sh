#!/bin/bash

render_dir="$(mktemp -d)"
pull_dir="$(mktemp -d)"

cleanup () {
  rm -r "${render_dir}"
  rm -r "${pull_dir}"
}

# extract helm archive
case "$1" in
  *://*)
    printf "%s\n" "Pulling chart..."
    # can probably assume this
    chartname=$(basename $1)
    # if our chart location looks like a url, pull and extract it
    helm pull -d "${pull_dir}" --untar --untardir "${render_dir}" "$1/$chartname"
    ;;
  *.tgz)
    # if our chart location looks like a tgz, extract it
    tar -C "${render_dir}" -xvf "$1"
    ;;
  *)
    # if not it's probably just a directory I guess?
    if [[ -d "$1" ]]; then
      cp -r "$1" "${render_dir}"
    else
      # exit if it's not though, we don't want to confuse helm
      printf "%s\n" "I'm not sure what your chart repo actually is."
      exit 1
    fi
    ;;
esac

# inject preflight.yaml into templates and render
# piping into preflight for actual checks
while read chart ; do
  preflight fetch "$1" > "${render_dir}/${chart}/templates/preflight.yaml"
  ${HELM_BIN} template "${render_dir}/$chart" | preflight -
done < <(ls "${render_dir}")

cleanup