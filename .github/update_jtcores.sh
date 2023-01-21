#!/usr/bin/env bash
# Copyright (c) 2021-2022 José Manuel Barroso Galindo <theypsilon@gmail.com>

set -euo pipefail

curl -o /tmp/update_distribution.source "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/update_distribution.sh"

source /tmp/update_distribution.source
rm /tmp/update_distribution.source

curl -o /tmp/calculate_db.py "https://raw.githubusercontent.com/MiSTer-devel/Distribution_MiSTer/develop/.github/calculate_db.py"
chmod +x /tmp/calculate_db.py

update_jtcores() {
    local OUTPUT_FOLDER="$(cd ${1} ; pwd)"
    local PUSH_COMMAND="${2:-}"

    # get list of cores from the wiki
    fetch_core_urls

    local TMP_FOLDER="$(mktemp -d)"
    
    # checkout jtbin repository in tmp folder
    download_repository "${TMP_FOLDER}" "https://github.com/jtfpga/temp.git" "master"

    mkdir -p "${OUTPUT_FOLDER}/_Arcade/cores/"

    for folder in $(echo "${CORE_URLS[@]}" | sed -n -e 's%^.*tree/master/%%p') ; do

        for bin in $(files_with_no_date "${TMP_FOLDER}/${folder}/releases" | uniq) ; do
            get_latest_release "${TMP_FOLDER}/${folder}" "${bin}"
            local LAST_RELEASE_FILE="${GET_LATEST_RELEASE_RET}"

            if is_not_rbf_release "${LAST_RELEASE_FILE}" ; then
                continue
            fi

            # for each core it copies the RBF file to _Arcade/cores/
            echo copy_file "${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}" "${OUTPUT_FOLDER}/_Arcade/cores/$(basename ${LAST_RELEASE_FILE})"
            copy_file "${TMP_FOLDER}/${folder}/releases/${LAST_RELEASE_FILE}" "${OUTPUT_FOLDER}/_Arcade/cores/$(basename ${LAST_RELEASE_FILE})"
        done
    done

    local IFS=$'\n'

    pushd ${TMP_FOLDER}

    # we copy each MRA not in _alternatives to _Arcade/
    #  * Assumption 1: all MRA files with the same name must be identical
    #  * Assumption 2: all MRA files must be compatible with MiSTer
    for mra in $(find mra -type f -iname '*.mra' -not -path "*/_alternatives/*") ; do
        echo copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
        copy_file "${mra}" "${OUTPUT_FOLDER}/_Arcade/$(basename ${mra})"
    done

    pushd mra

    # we copy each MRA in _alternatives to _Arcade/_alternatives keeping same tree folder structure
    #  * Assumption: all MRA alternatives must be compatible with MiSTer
    for alts in $(find _alternatives/ -type f -iname '*.mra') ; do
        echo copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
        copy_file "${alts}" "${OUTPUT_FOLDER}/_Arcade/${alts}"
    done

    popd
    popd

    echo
    IFS=$'\n'
    for mra in $(grep -lR 'jtbeta.zip' "${OUTPUT_FOLDER}/_Arcade/") ; do
        echo "Removing: ${mra}";
        rm "${mra}"
    done
    echo

    if [[ "${PUSH_COMMAND}" == "--push" ]] ; then
        git checkout -f develop -b main
        echo "Running detox"
        detox -v -s utf_8-only -r *
        echo "Detox done"
        git add "${OUTPUT_FOLDER}"
        git commit -m "-"
        git fetch origin main || true
        echo "Calculating db..."
        /tmp/calculate_db.py
    fi

    rm -rf "${TMP_FOLDER}"
}

fetch_core_urls() {
    CORE_URLS=$(curl -sSLf "https://github.com/jotego/jtbin/wiki"| awk '/Arcade-Cores-Top/,/Arcade-Cores-Bottom/' | grep -ioE "https://github.com/jotego/jtbin/tree/[a-zA-Z0-9./_-]*")
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]] ; then
    update_jtcores "${1}" "${2:-}"
fi
