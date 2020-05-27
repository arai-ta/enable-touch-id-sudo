#!/bin/sh

set -eu

FILE=/etc/pam.d/sudo

is_dryrun() {
    test "x${1:-}" = "x-d" -o \
         "x${1:-}" = "x--dry-run"
}

is_installed() {
    grep "pam_tid.so" $FILE > /dev/null
}

show() {
    uname -a
    cat $FILE
}

install() {
    sed -i.bak -e '2i\
auth       sufficient     pam_tid.so' $FILE
}

if is_dryrun $@
then
    show
elif is_installed
then
    echo "Already installed. stop."
    show
else
    echo   "Do install. It requires superuser permission."
    printf "OK? [enter to continue / CTRL-c to stop] :"
    read
    install
fi

