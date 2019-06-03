#!/bin/bash

cat << EOF > /etc/samba/smb.conf
[global]
        workgroup = SAMBA
        security = user
        passdb backend = smbpasswd
        load printers = no
	min protocol = SMB2
EOF

VOLUMES_tmp="$VOLUMES"
#ensure VOLUMES_tmp isn't empty and contains more than 1 field (more than one `:`)
if [ x"$VOLUMES" = x"${VOLUMES%;*}" -o x"$VOLUMES" = x ];then
cat << EOF
Volumes must be specified as follows:
sharename;/mnt/where

You may have more than 1 share specified:
share1;server1;vol1;path1;share2;server;vol2;path2
EOF
exit 1
fi

while [ x != x"$VOLUMES_tmp" ];do
    SHARE="$(echo "$VOLUMES_tmp" | cut -f 1 -d ';')"
    VOLUME="$(echo "$VOLUMES_tmp" | cut -f 2 -d ';')"
    VOLUMES_tmp="$(echo "$VOLUMES_tmp" | cut -f 3- -d ';')"
    if [ x = "$VOLUME" ];then
        VOLUME=/
    fi
cat << EOF >> /etc/samba/smb.conf    
[$SHARE]
path = $VOLUME
       browseable = yes
       guest ok = no
       writeable = yes
EOF
done

truncate --size 0 /var/lib/samba/private/smbpasswd 
USERS_tmp="$USERS"

while [ x != x"$USERS_tmp" ];do
    USER="$(echo "$USERS_tmp" | cut -f 1 -d ';')"
    ID="$(echo "$USERS_tmp" | cut -f 2 -d ';')"
    HPWD="$(echo "$USERS_tmp" | cut -f 3 -d ';')"
    USERS_tmp="$(echo "$USERS_tmp" | cut -f 4- -d ';')"
groupadd -f -g $ID james
useradd -u $ID -g $ID -M james

cat << EOF >> /var/lib/samba/private/smbpasswd 
$USER:$ID:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:$HPWD:[U          ]:LCT-5CF4BD19:
EOF
echo added user $USER
done

smbd -F -S -d 2
