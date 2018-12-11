  FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
ARG TERM=Linux

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
                   readline-common \
                   locales \
                   libapache2-mod-php \
                   dbus \
                   supervisor \
                   ntp

RUN touch /usr/share/locale/locale.alias
RUN sed -i -e 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8   

COPY ./docker/supervisor.conf /etc/
COPY ./docker/supervisor/ /etc/supervisor/
COPY ./docker/netboot.sh /opt/
COPY ./docker/ldapproxy.sh /opt/
copy ./docker/webapp.sh /opt/
COPY . /netsus

RUN /netsus/CreateNetSUSInstaller.sh

RUN sudo groupadd lpadmin
RUN sudo groupadd sambashare

RUN yes | sudo /netsus/NetSUSLPInstaller.run -- -y

#ENTRYPOINT ["/bin/bash", "--"]

CMD supervisord -c /etc/supervisor.conf
