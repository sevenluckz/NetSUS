FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="https://github.com/sevenluckz/NetSUS" \
      description="JAMF NetSUS Server"

# BSDP (NetBoot Discovery)
EXPOSE 67/udp 68/udp 			

# TFTP
EXPOSE 69/udp 					

# HTTP
EXPOSE 80/tcp 443/tcp			

# SSH
EXPOSE 22/tcp					

# NFS (TCP)
EXPOSE 111/tcp 892/tcp 2049/tcp	

# NFS (UDP)
EXPOSE 111/udp 892/udp 2049/udp	

# AFP
EXPOSE 548/tcp					

# SMB
EXPOSE 139/tcp 445/tcp

WORKDIR /netsus

RUN apt update \
 && apt install -y apt-utils \
 && apt install -y software-properties-common \
                   dialog \
                   sudo \
                   readline-common
            
COPY . /netsus

RUN sudo groupadd lpadmin
RUN sudo groupadd sambashare

RUN sudo /netsus/NetSUSLPInstaller.run --nox11 -- -y

ENTRYPOINT ["/sbin/tini", "--"]