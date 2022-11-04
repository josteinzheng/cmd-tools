#!/bin/bash

echo current ip is $1

yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast

yum -y install docker-ce-18.03.1.ce-1.el7.centos
systemctl start docker
systemctl status docker

mkdir -p /etc/docker
tee /etc/docker/daemon.json <<-'EOF'
{
  "registry-mirrors": ["https://wa0mpwjo.mirror.aliyuncs.com"],
  "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
systemctl daemon-reload
systemctl restart docker
systemctl daemon-reload

wget https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
wget https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
rpm --import yum-key.gpg
rpm --import rpm-package-key.gpg

tee /etc/yum.repos.d/kubernates.repo <<-'EOF'
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

yum clean all
yum -y makecache
yum install -y kubelet-1.17.5 kubeadm-1.17.5 kubectl-1.17.5

tee /etc/sysconfig/kubelet <<-'EOF'
KUBELET_EXTRA_ARGS="--cgroup-driver=systemd"
EOF

systemctl enable kubelet


images=(
        kube-apiserver:v1.17.5
        kube-controller-manager:v1.17.5
        kube-scheduler:v1.17.5
        kube-proxy:v1.17.5
        pause:3.1
        etcd:3.4.3-0
        coredns:1.6.5
)
for imageName in ${images[@]}
do
  docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
  docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
  docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/$imageName
done

docker pull calico/cni:v3.14.2
docker pull calico/pod2daemon-flexvol:v3.14.2
docker pull calico/node:v3.14.2
docker pull calico/kube-controllers:v3.14.2

kubeadm init --apiserver-advertise-address=$1 --kubernetes-version v1.17.5 --service-cidr=10.1.0.0/16 --pod-network-cidr=10.81.0.0/16
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

