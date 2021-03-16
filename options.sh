#!/bin/bash

loop() {
  FN="$@"
  for opt in ${OPTIONS[@]}; do
    IFS=', ' read -r -a array <<< "$opt"
    $FN ${array[0]} ${array[1]} ${array[2]}
  done
}

usage() {
  echo -n "Usage: $0"
  λ() { echo -n " $1 <$3>"; }
  loop λ
  echo; exit 1
}

loadOptions() {
  while [[ $# -gt 0 ]]; do
    OPT="$1"
    λ() { if [[ $OPT == $1 ]]; then echo $2; fi }
    variable=$(loop λ)
    if [[ $variable ]]; then
      eval $variable=\"$2\"; [[ $# -gt 1 ]] && shift 2 || shift
    else
      usage
    fi
  done

  λ() { if [ -z "$(eval echo \$$2)" ]; then usage; fi }
  loop λ
}

#
# Example Usage
#
# OPTIONS=(
#   --username,USERNAME,string
#   --password,PASSWORD,string
#   --api-token,API_TOKEN,string
#   --repo-url,REPO_URL,string
#   --org,ORG,string
#   --list,LIST,string
# )
#
# loadOptions "$@"
#
