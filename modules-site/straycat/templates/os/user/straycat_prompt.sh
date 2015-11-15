#!/bin/sh

# Set our custom prompt
. /etc/default/straycat
if [ "$PS1" ]; then
    PS1="[\u@\h ${STRAYCAT_SVC}:${STRAYCAT_ENV} \W]\\$"
fi
