#!/bin/bash

#yum install -y docker

#systemctl start docker
#systemctl enable docker

#docker pull kylemanna/openvpn


#域名需要跟实际公网ip对应上
portal_hostname=portal.josteinzheng.cn
username=jostein

#docker ps
#docker rm $containerId

# Pick a name for the $OVPN_DATA data volume container. 
# It's recommended to use the ovpn-data- prefix to operate seamlessly with the reference systemd service. 
# Users are encourage to replace example with a descriptive name of their choosing.
OVPN_DATA="ovpn-data-zheng"

#Initialize the $OVPN_DATA container that will hold the configuration files and certificates. 
#The container will prompt for a passphrase to protect the private key used by the newly generated certificate authority.
docker volume create --name $OVPN_DATA
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$portal_hostname
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn ovpn_initpki

#Start OpenVPN server process
docker run --restart=always -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn

#Generate a client certificate without a passphrase
docker run -v $OVPN_DATA:/etc/openvpn --rm -it kylemanna/openvpn easyrsa build-client-full $username nopa

#Retrieve the client configuration with embedded certificates
docker run -v $OVPN_DATA:/etc/openvpn --rm kylemanna/openvpn ovpn_getclient $username> $username.ovpn

#firewall-cmd --zone=public --add-port=1194/upd --permanent
#firewall-cmd --reload


#FAQ
# 1. 防火墙或安全组需要开放udp端口1194，如果访问不同可以尝试换个外网ip（有可能ip被ban了)
