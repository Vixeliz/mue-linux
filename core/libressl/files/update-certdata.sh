#!/bin/sh -e
#
# update-certdata.sh

[ -w "$CPT_ROOT/etc/ssl" ] || {
    printf '%s\n' "${0##*/}: root required to update CA certificates." >&2
    exit 1
}

cd "$CPT_ROOT/etc/ssl" && {
    wget https://curl.haxx.se/ca/cacert.pem
    mv -f cacert.pem cert.pem
    printf '%s\n' "${0##*/}: updated cert.pem"
}
