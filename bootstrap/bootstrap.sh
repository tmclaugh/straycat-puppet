#!/bin/sh
#
# Bootstrap a puppetmaster.  Meant to be a temporary host.
#

BS_DIR=$(dirname $0)

puppet apply \
    --verbose \
    --modulepath ${BS_DIR}/../modules:${BS_DIR}/../modules-site \
    -e 'include ::straycat::roles::bootstrap'