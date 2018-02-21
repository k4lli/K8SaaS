#!/bin/bash
 
# Install yum-utils
if ! rpm -qa | grep -qw yum-utils; then
/usr/bin/yum install -y yum-utils
fi
 
# Configure repo
if [ -f /etc/yum.repos.d/kubernetes.repo ]; then
# Enable Kubernetes repo
/usr/bin/yum-config-manager --enable Kubernetes
else
# Create and enable Kubernetes repo
cat <<EOF> /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
fi
 
# Install Kubernetes and Docker
/usr/bin/yum install kubeadm docker -y
 
# Enable service
/usr/bin/systemctl enable docker
 
# Start service
echo "Starting Docker"
/usr/bin/systemctl start docker
/usr/bin/docker version
 
# Disable Kubernetes repo
/usr/bin/yum-config-manager --disable kubernetes