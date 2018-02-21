#!/bin/bash
 
# Set a proper PATH, 'cos vRA um, doesn't...
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
# Checks to see if Kubernetes Dashboard is required
#if [ $dashboard == true ]; then
        echo "Kubernetes Monitoring is required, installing"
        export KUBECONFIG=/etc/kubernetes/admin.conf
        
        # Download Yamls
		mkdir -p ~/k8s/heapster
		cd ~/k8s/heapster
		wget https://raw.githubusercontent.com/kalliz/K8SaaS/master/grafana.yaml
		wget https://raw.githubusercontent.com/kalliz/K8SaaS/master/heapster-rbac.yaml
		wget https://raw.githubusercontent.com/kalliz/K8SaaS/master/heapster.yaml
		wget https://raw.githubusercontent.com/kalliz/K8SaaS/master/influxdb.yaml
		
		
		#install grafana and influxdb
		kubectl create -f ~/k8s/heapster/grafana.yaml
		kubectl create -f ~/k8s/heapster/influxdb.yaml

#else
#        echo "Kubernetes Dashboard is not required"
#fi