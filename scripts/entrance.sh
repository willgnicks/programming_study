#!/bin/bash

PUBLIC=$(pwd)"/public.sh"
if [[ ! -f "$PUBLIC" ]];then
    echo "[ERROR] Shell script, $PUBLIC, do not exist. This script exit! [ERROR] "
    exit
fi
source "$PUBLIC"

splitline "*"
makeDirs "$DEFAULT_SOFTWARE_PATH" "$DEFAULT_SOFTWARE_DIRS"

SCRIPTS=$(ls)

for script in ${SCRIPTS[*]};do
    echo "$script"
done