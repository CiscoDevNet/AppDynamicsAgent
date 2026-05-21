#!/bin/sh
#
#  xcode_build_dsym_upload.sh
#
#  Copyright (c) 2014 AppDynamics Inc. All rights reserved.
#
#  Documentation: Please refer to AppDynamics Inc. documentation of how to use this script inside Xcode.
#

# These values can be set externally if you wish to change the defaults
ADRUM_UPLOAD_WHEN_BUILT_FOR_SIMULATOR=${ADRUM_UPLOAD_WHEN_BUILT_FOR_SIMULATOR:=1}
ADRUM_TREAT_UPLOAD_FAILURES_AS_ERRORS=${ADRUM_TREAT_UPLOAD_FAILURES_AS_ERRORS:=1}
ADRUM_EUM_PROCESSOR=${ADRUM_EUM_PROCESSOR:="https://api.eum-appdynamics.com"}

# Script starts here

# Helper functions
echoMessageAndExitWithCode() {
    echo "${1}"
    exit ${2}
}

rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""

    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] ) o="${c}" ;;
            * )               printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

dsymIDForUploading() {
    local dsym_pkg="${1}"

    # There can be several UUIDs in one dSYM, try them all.
    for uuid in $(dwarfdump --uuid "${dsym_pkg}" | cut -d ' ' -f 2); do
        status=$(curl --silent --output /dev/null -w "%{http_code}" \
                      --user "${ADRUM_ACCOUNT_NAME}:${ADRUM_LICENSE_KEY}" \
                      "${ADRUM_EUM_PROCESSOR}/v2/account/${ADRUM_ACCOUNT_NAME}/crash-symbol-file-query/dsym/uuid/${uuid}")

        if [ "${status}" != "200" ]; then
            echo $uuid
            return
        fi
    done
    echo ""
}

zipDsym() {
    local dsym_pkg="${1}"
    NOW=$(date +"%T")
    echo "Time: ${NOW}. Compressing ${dsym_pkg} ..."
    UTC_MS=$(python -c 'import time; print(int(time.time() * 1000))')
    echo "UTC time milliseconds: ${UTC_MS}."
    zip --recurse-paths --quiet "${dsym_pkg}.zip" "${dsym_pkg}" || echoMessageAndExitWithCode "error: failed to create ${dsym_pkg}.zip" "$?"
    echo ""
    NOW=$(date +"%T")
    echo "Time: ${NOW}. Successfully compressed dSYM to ${dsym_pkg}.zip"
    ZIP_SIZE="$(wc -c <"${dsym_pkg}.zip")"
    echo "Zip file size: ${ZIP_SIZE}"
}

uploadDsym() {
    local dsym_zip="${1}"

    NOW=$(date +"%T")
    echo "Time ${NOW}. Started uploading dSYM to AppDynamics EUM Processor. URL: ${DSYM_UPLOAD_URL}..."
    ACCOUNT_NAME_ENCODED=$( rawurlencode "${ADRUM_ACCOUNT_NAME}" )
    ADRUM_LICENSE_KEY_ENCODED=$( rawurlencode "${ADRUM_LICENSE_KEY}" )

    HTTP_STATUS=$(curl --silent --output /dev/null -w "%{http_code}" -H "Content-Type:application/octet-stream" --upload-file "${dsym_zip}" --user "${ACCOUNT_NAME_ENCODED}:${ADRUM_LICENSE_KEY_ENCODED}" "${DSYM_UPLOAD_URL}")
    CURL_STATUS=$?
    NOW=$(date +"%T")
    echo "Time ${NOW}. Upload attempt completed. curl return code: ${CURL_STATUS}"

    if [ $CURL_STATUS -eq 0 ]; then
        echo "HTTP Status Code: ${HTTP_STATUS}"
    fi
}

deleteTemporaryZip() {
    local dsym_zip="${1}"
    echo "Deleting temporary dSYM archive: ${dsym_zip}"
    rm -f "${dsym_zip}"
}

checkUploadStatus() {
    if [ $HTTP_STATUS -ne 200 -o $CURL_STATUS -ne 0 ]; then
        if [ $ADRUM_TREAT_UPLOAD_FAILURES_AS_ERRORS -eq 1 ]; then
            MESSAGE=$(printf "error: dSYM archive upload failed\nTo ignore this condition and build succesfully, add:\nADRUM_TREAT_UPLOAD_FAILURES_AS_ERRORS=0\nto the environment before invoking this script")
            echoMessageAndExitWithCode "${MESSAGE}" 1
        fi
        echo "warning: dSYM archive upload failed, but ignored due to ADRUM_TREAT_UPLOAD_FAILURES_AS_ERRORS=0"
    fi
    echo "dSYM uploaded successfully to AppDynamics EUM Processor"
}

echo "Uploading dSYM to AppDynamics EUM Processor"
echo ""

# Check to make sure the necessary parameters are defined
if [ ! "${ADRUM_ACCOUNT_NAME}" ]; then
    echoMessageAndExitWithCode "error: ADRUM_ACCOUNT_NAME is not defined." 1
fi

if [ ! "${ADRUM_LICENSE_KEY}" ]; then
    echoMessageAndExitWithCode "error: ADRUM_LICENSE_KEY is not defined." 1
fi

# Print product information
BUNDLE_VERSION=$(/usr/libexec/PlistBuddy -c 'Print CFBundleVersion' "${INFOPLIST_FILE}")
BUNDLE_SHORT_VERSION=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "${INFOPLIST_FILE}")

echo "Product Name: ${PRODUCT_NAME}"
echo "Product Version: ${BUNDLE_SHORT_VERSION}"
echo "Product Build: ${BUNDLE_VERSION}"

# Print AppDynamics information
echo "AppDynamics EUM Account Name: ${ADRUM_ACCOUNT_NAME}"
echo "AppDynamics EUM License Key: ${ADRUM_LICENSE_KEY}"
echo "AppDynamics EUM Processor: ${ADRUM_EUM_PROCESSOR}"

# Check if this is a simulator build
if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
if [ $ADRUM_UPLOAD_WHEN_BUILT_FOR_SIMULATOR -eq 0 ]; then
    echoMessageAndExitWithCode "info: simulator build - ADRUM_UPLOAD_WHEN_BUILT_FOR_SIMULATOR is 0 (false). Skipping upload" 0
fi
fi

APP_DSYM=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}

# Check if App dSym file exists
echo "App dSYM file location: ${APP_DSYM}"
if [ ! -d "$APP_DSYM" ]; then
    echoMessageAndExitWithCode "error: App dSYM file not found at: ${APP_DSYM}" 1
fi

DSYM_UPLOAD_URL="${ADRUM_EUM_PROCESSOR}/v2/account/${ADRUM_ACCOUNT_NAME}/ios-dsym"

# Find all dsym files
find "${DWARF_DSYM_FOLDER_PATH}" -type d -name \*.dSYM -print |
    while read dsym; do
        DSYM_UUID=$(dsymIDForUploading "${dsym}")
        if [[ $DSYM_UUID == '' ]]; then
            echo "Skipping ${dsym} because it is already been uploaded."
            continue
        fi

        echo "dSYM UUID: ${DSYM_UUID}"

        # Compress dsym to zip
        zipDsym "${dsym}"

        # Upload dsym zip
        uploadDsym "${dsym}.zip"

        # Delete temp zip
        deleteTemporaryZip "${dsym}.zip"

        # Check upload status
        checkUploadStatus
    done
