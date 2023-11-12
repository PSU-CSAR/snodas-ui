#!/usr/bin/env bash

set -eux -o pipefail

_WINDIR="$(cygpath -u "${WINDIR}")"
APPCMD="${_WINDIR}/system32/inetsrv/appcmd.exe"
SITE_NAME="snodas-ui"
BINDING="https://snodas.geog.pdx.edu:443"


find_this () {
    THIS="${1:?'must provide script path, like "${BASH_SOURCE[0]}" or "$0"'}"
    trap "echo >&2 'FATAL: could not resolve parent directory of ${THIS}'" EXIT
    [ "${THIS:0:1}"  == "/" ] || THIS="$(pwd -P)/${THIS}"
    THIS_DIR="$(dirname -- "${THIS}")"
    THIS_DIR="$(cd -P -- "${THIS_DIR}" && pwd)"
    THIS="${THIS_DIR}/$(basename -- "${THIS}")"
    trap "" EXIT
}

find_this "${BASH_SOURCE[0]}"
    
PROJECT_DIR="${THIS_DIR}/../webroot"


main () {
    echo >&2 "Adding IIS App Pool..."
    $APPCMD add apppool "/name:${SITE_NAME}" ||:

    echo >&2 "Adding IIS Site..."
    $APPCMD add site "/name:${SITE_NAME}" "/bindings:${BINDING}" "/physicalPath:$(cygpath -w ${PROJECT_DIR})" ||:

    echo >&2 "Assigning App Pool to  IIS Site..."
    $APPCMD set app "${SITE_NAME}/" "/applicationPool:${SITE_NAME}" || :

    echo >&2 "Granting App Pool access to project directory (${PROJECT_DIR})..."
    ICACLS "$(cygpath -w ${PROJECT_DIR})" //T //grant "IIS AppPool\\${SITE_NAME}:F"


    cat <<"EOF" >&2
PLEASE NOTE: This command is unable to set
the certificate to use for the specified binding.
Please use the IIS tool to edit the binding and
set the correct certificate:

1) Open IIS
2) Expand the "Sites" in the left navigation panel
3) Right-click "${SITE_NAME}" and choose "Edit Bindings"
4) Edit the binding and choose the correct SSL Certificate
EOF

}


main "$@"
