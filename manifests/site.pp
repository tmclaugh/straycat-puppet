import "exec.pp"
# Disable because we have Foreman
#import "nodes/*.pp"

# Just make stdlib available for use.  This also establishes our stages
# as well.  See stdlib::stages.
include stdlib

