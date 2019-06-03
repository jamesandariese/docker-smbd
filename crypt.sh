#!/bin/bash

cat << EOF > /etc/samba/smb.conf
[global]
        workgroup = SAMBA
        security = user
        passdb backend = smbpasswd
        load printers = no
EOF


useradd -u 1000 -M blah 2>/dev/null
echo 'blah:1000:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:A9F0DD57E1EDAB5BB55A9AC0A99C15EC:[U          ]:LCT-5CF4BD19:' > /var/lib/samba/private/smbpasswd
smbpasswd blah 
cat /var/lib/samba/private/smbpasswd | cut -d: -f4
