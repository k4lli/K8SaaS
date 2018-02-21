#!/bin/bash
 
# Set a proper PATH, 'cos vRA um, doesn't...
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
# Checks if this host is the Master
if [ $role == "Master" ]; then

    echo "This host is the master, running kubeadm init"

    # Enable and start the services
    /usr/bin/systemctl enable kubelet
    /usr/bin/systemctl start kubelet
    
    # Disable system swap
    /usr/sbin/swapoff -a
    
    # Initialize cluster
    /usr/bin/kubeadm init
    
    # Get Kubernetes version
    export KUBECONFIG=/etc/kubernetes/admin.conf
    export kubever=$(kubectl version | base64 | tr -d '\n')
    
    #without this localhost:8080 problems when running kubectl
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    
    # Install pod network
    /usr/bin/kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
    
    # Export token for joining the cluster
    nToken=$(kubeadm token create --print-join-command)
    export nToken

else

    echo "This host is a node, joining Kubernetes cluster"
    
    # Disable system swap
    /usr/sbin/swapoff -a

    # Join command as received from master (nTokenN)
    echo "join command nTokenN: "$nTokenN
    
    $nTokenN    
fi