#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
 
# Checks to see if Monitoring is required (NOT Implemented YET!!! monitoring is always installed)
#if [ $monitoring == true ]; then # as above. its always true
export KUBECONFIG=/etc/kubernetes/admin.conf
        
#get Influx DB IP and adjust in heapster.yaml
INFLUXDBIP=$(kubectl describe service/monitoring-influxdb -n kube-system |grep IP\: | awk '{print $2}')
sed -i "s/INFLUXDBIP/${INFLUXDBIP}/g" ~/k8s/heapster/heapster.yaml

#get Cluster API IP AND PORT and adjust in heapster.yaml
CLUSTERAPIIPPORT=$(kubectl describe service |grep Endpoints\: | awk '{print $2}')
sed -i "s/CLUSTERAPIIPPORT/${CLUSTERAPIIPPORT}/g" ~/k8s/heapster/heapster.yaml

#install heapster
kubectl create -f ~/k8s/heapster/heapster.yaml
kubectl create -f ~/k8s/heapster/heapster-rbac.yaml

#expose grafana
kubectl patch service monitoring-grafana -n kube-system -p '{"spec":{"type":"NodePort"}}'

GRAFANAPORT=$(kubectl describe service monitoring-grafana -n kube-system|grep NodePort\: | awk '{print $3}')

# create Grafana IP and port variable for output
GRAFANA=$(echo $CLUSTERAPIIPPORT | grep -o '.*:')
GRAFANA="$GRAFANA$GRAFANAPORT"

echo
echo
echo "Use your browser to connect to the Kubernetes Master on "$GRAFANA
echo
