# $Id: vars.pp 1002 2012-06-24 20:30:39Z tom $
#
# XXX: All sensitive information such as passwords should be placed in
# vars.private.pp which has increased access restrictions in SVN.
#

# Hadoop
$hadoop_job_tracker = "hdp0.straycat.dhs.org"
$hadoop_namenode = "hdp0.straycat.dhs.org"
$zookeeper_quorum_node = "hdp0.straycat.dhs.org"

# HTTPD
#$httpd_sslcertfile = 
#$httpd_sslkeyfile = 
$proxy_ip = "192.168.1.?"