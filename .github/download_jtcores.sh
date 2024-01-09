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

    local IFS=$'\n'
    cp ${TMP_FOLDER}/mister/* "${OUTPUT_FOLDER}/_Arcade/cores/"
    cp -r ${TMP_FOLDER}/mra/* "${OUTPUT_FOLDER}/_Arcade/"

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

copy_file() {
    local SOURCE="${1}"
    local TARGET="${2}"

    mkdir -p "${TARGET%/*}"
    cp -r "${SOURCE}" "${TARGET}"
}

is_not_rbf_release() {
    is_not_file_extension "${1}" "rbf"
}

is_not_file_extension() {
    local INPUT_FILE="${1}"
    local EXPECTED_EXTENSION="${2}"
    if is_file_extension "${INPUT_FILE}" "${EXPECTED_EXTENSION}" ; then
        return 1
    fi
    >&2 echo "${INPUT_FILE} is NOT a ${EXPECTED_EXTENSION^^} file."
    return 0
}

is_file_extension() {
    local INPUT_FILE="${1}"
    local EXPECTED_EXTENSION="${2}"
    local ACTUAL_EXTENSION="${INPUT_FILE#*.}"
    if [[ "${INPUT_FILE}" == "" ]] || [[ "${ACTUAL_EXTENSION,,}" != "${EXPECTED_EXTENSION,,}" ]] ; then
        return 1
    fi
    return 0
}

files_with_no_date() {
    local FOLDER="${1}"
    pushd "${FOLDER}" > /dev/null 2>&1
    for file in *; do
        if ! [[ "${file}" =~ ^.+_([0-9]{8})(\..+)?$ ]] ; then
            echo "${file}"
        fi
    done
    popd > /dev/null 2>&1
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    download_jtcores "${1}"
fi