#!/bin/bash

# set -u -e -o pipefail

readonly thisDir=$(cd $(dirname $0); pwd)

cd $(dirname $0)/../..

DIST="$(pwd)/dist"
ROOT=${DIST}/delon-builds

NEXT=false
for ARG in "$@"; do
  case "$ARG" in
    -next)
      NEXT=true
      ;;
  esac
done

VERSION=$(node -p "require('./package.json').version")
echo "Version ${VERSION}"

clone() {
  rm -rf ${ROOT}
  mkdir -p ${ROOT}
  cd ${DIST}
  echo ">>> Clone delon & cli dist..."
  git clone --depth 1 https://github.com/software2010/delon7.7.1.git
}

publishToMaster() {
  (cd ${ROOT}/@delon; for p in `ls .`; do npm publish --access public $p; done)

}

publishToNext() {
  (cd ${ROOT}/@delon; for p in `ls .`; do npm publish $p --access public --tag next; done)

}


clone
if [[ ${NEXT} == true ]]; then
  publishToNext
else
  publishToMaster
fi
