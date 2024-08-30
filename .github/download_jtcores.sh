#!/usr/bin/env bash
# Copyright (c) 2023 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

download_jtcores() {
    local OUTPUT_FOLDER="$(cd ${1} ; pwd)"
    echo "OUTPUT_FOLDER=${OUTPUT_FOLDER}"

    local TMP_FOLDER="$(mktemp -d)"

    # checkout jtbin repository in tmp folder
    download_repository "${TMP_FOLDER}" "https://github.com/jotego/jtbin.git" "master"

    mkdir -p "${OUTPUT_FOLDER}/_Arcade/cores/"
    mkdir -p "${OUTPUT_FOLDER}/_Console"

    local IFS=$'\n'
    cp ${TMP_FOLDER}/mister/jt* "${OUTPUT_FOLDER}/_Arcade/cores/"
    cp -r ${TMP_FOLDER}/mra/* "${OUTPUT_FOLDER}/_Arcade/"
    cp ${TMP_FOLDER}/neogeopocket.rbf "${OUTPUT_FOLDER}/_Console/NeoGeoPocket.rbf"

    # NeoGeo Pocket games folder
    mkdir -p "${OUTPUT_FOLDER}/games/NeoGeoPocket/"
    touch "${OUTPUT_FOLDER}/games/NeoGeoPocket/.delme"

    rm -rf "${TMP_FOLDER}"
}

download_repository() {
    local FOLDER="${1}"
    local GIT_URL="${2}"
    local BRANCH="${3}"
    pushd "${TMP_FOLDER}" > /dev/null 2>&1
    git init -q
    git remote add origin "${GIT_URL}"
    git -c protocol.version=2 fetch --depth=1 -q --no-tags --prune --no-recurse-submodules origin "${BRANCH}"
    git checkout -qf FETCH_HEAD
    popd > /dev/null 2>&1
}

# if the file is not sourced, download the cores
if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    download_jtcores "${1}"
fi
