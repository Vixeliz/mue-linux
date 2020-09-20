#!/bin/sh -e
#
# update-certdata

DEST="$CPT_ROOT/etc/certificates"

[ -d "$DEST" ]  || mkdir -p "$DEST"

[ -w "$DEST" ] || {
    printf '%s\n' "${0##*/}: root required to update CA certificates." >&2
    exit 1
}

wget https://curl.haxx.se/ca/cacert.pem -O "$DEST/cert.pem"
printf '%s\n' "${0##*/}: updated cert.pem"
