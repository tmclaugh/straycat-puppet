#!/bin/sh
#
# Bootstrap a puppetmaster.  Meant to be a temporary host.
#

BS_DIR=$(dirname $0)

# Setup puppetmaster
puppet apply \
    --verbose \
    --modulepath ${BS_DIR}/../modules:${BS_DIR}/../modules-site \
    -e 'include ::straycat::roles::bootstrap'

# deploy environment
r10k deploy environment -p -v
