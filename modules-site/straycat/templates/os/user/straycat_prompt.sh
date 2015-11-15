#!/bin/sh

# Set our custom prompt
. /etc/default/straycat

if [ "${STRAYCAT_ENV}" = 'prod' ]; then
    if [ $(id -u) = '0' ]; then
        color_start='\e[0;31m'
        color_stop='\e[m'
    else
        color_start='\e[0;91m'
        color_stop='\e[m'
    fi
else
    color_start=''
    color_stop=''
fi

if [ "$PS1" ]; then
    PS1="${color_start}[\u@\h ${STRAYCAT_SVC}:${STRAYCAT_ENV} \W]\\$ ${color_stop}"
fi
