FROM fedora:30

RUN dnf update -y
RUN dnf install -y samba-vfs-glusterfs
COPY start.sh /

CMD /start.sh
