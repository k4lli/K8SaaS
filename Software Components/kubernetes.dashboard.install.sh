#!/bin/bash
 
# Set a proper PATH, 'cos vRA um, doesn't...
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
# Checks to see if Kubernetes Dashboard is required
if [ $dashboard == true ]; then
        echo "Kubernetes Dashboard is required, installing"
        export KUBECONFIG=/etc/kubernetes/admin.conf
        # Deploy the dashboard
        kubectl create -f $url
else
        echo "Kubernetes Dashboard is not required"
fi