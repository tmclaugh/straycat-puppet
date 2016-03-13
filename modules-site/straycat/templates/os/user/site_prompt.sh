#!/bin/sh

# Set our custom prompt
. /etc/default/site

if [ "${SITE_ENV}" = 'prod' ]; then
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
    PS1="${color_start}[\u@\h ${SITE_SVC}:${SITE_ENV} \W]\\$ ${color_stop}"
fi
