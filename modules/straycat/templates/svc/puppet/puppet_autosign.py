#!/usr/bin/env python

import subprocess
import sys

OID='1.3.6.1.4.1.34380.1.1.4'

certname = sys.argv[1]
client_csr = sys.stdin.read()

proc = subprocess.Popen(['openssl', 'req', '-text', '-noout'], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
proc.stdin.write(client_csr)
proc.stdin.close()
proc.wait()
client_csr_text = proc.stdout.readlines()

master_psk = file('/etc/puppet/puppet_psk', 'r').readline().strip()

found_oid=False

for line in client_csr_text:
    if found_oid:
        if line.strip() == master_psk:
            print("SIGN_PASS: Signing CSR for %s" % certname)
            sys.exit(0)
        else:
            print("SIGN_FAIL: PSK in CSR wrong for %s" % certname)
            sys.exit(1)

    if line.strip()[:-1] == OID:
        found_oid = True

# Fail if we made it here.
print("SIGN_FAIL: No PSK found for %s" % certname)
sys.exit(1)
