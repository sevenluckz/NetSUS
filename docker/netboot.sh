#!/bin/bash

service tftpd-hpa start
service netatalk start
service smbd start
service nfs-kernel-server start
service avahi-daemon start
service rpcbind start
service pybsdp start

while true; do
	:
done