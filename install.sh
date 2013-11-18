#!/bin/bash

UTILS_DIR=`pwd`
RC_FILE="utils.rc"

function make_stderred {
    if [[ ! -f submodules/stderred/Makefile ]]
    then
        echo "stderred Makefile does not exists" > /dev/stderr
        exit 1
    fi
    cd submodules/stderred/

    make
    if [[ ! $? ]]
    then
        echo "Make failed" > /dev/stderr
        exit 1
    fi

    cd "$UTILS_DIR"
    mkdir -p lib
    ln -sf ../submodules/stderred/build/libstderred.so lib/
}

function create_rcfile {
    (
        echo -n ;\
        echo "# THIS FILE IS AUTOMATICALLY GENERATED BY INSTALL SCRIPT" ;\
        echo "# DON'T BOTHER EDITING IT" ;\
        echo "" ;\
        echo "export LD_PRELOAD=\"${UTILS_DIR}/lib/libstderred.so"'${LD_PRELOAD:+:$LD_PRELOAD}"'
    ) > $RC_FILE

    echo "Don't forget to source the .utils/utils.rc!"
}

make_stderred
create_rcfile

