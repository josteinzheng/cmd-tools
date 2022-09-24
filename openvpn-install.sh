#!/bin/bash

#yum install -y docker

#systemctl start docker
#systemctl enable docker

#docker pull kylemanna/openvpn:2.4

mkdir -p /data/openvpn

portal_hostname=portal.josteinzheng.cn
username=jostein

#docker ps
#docker rm $containerId

docker run -v /data/openvpn:/etc/openvpn --rm kylemanna/openvpn:2.4 ovpn_genconfig -u udp://$portal_hostname

docker run -v /data/openvpn:/etc/openvpn --rm -it kylemanna/openvpn:2.4 ovpn_initpki

docker run -v /data/openvpn:/etc/openvpn --rm -it kylemanna/openvpn:2.4 easyrsa build-client-full $username nopass

mkdir -p /data/openvpn/conf
docker run -v /data/openvpn:/etc/openvpn --rm kylemanna/openvpn:2.4 ovpn_getclient $username > /data/openvpn/conf/$username.ovpn
docker run --restart=always --name openvpn -v /data/openvpn:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn:2.4

#firewall-cmd --zone=public --add-port=1194/upd --permanent
#firewall-cmd --reload
