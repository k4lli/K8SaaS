#!/bin/bash
 
# Set admin variable
export KUBECONFIG=/etc/kubernetes/admin.conf
 
# Create RBAC rules
cat <<EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
EOF

# Expose Dashboard outside the cluster
kubectl patch service kubernetes-dashboard -n kube-system -p '{"spec":{"type":"NodePort"}}'
 
# Get external port
nodePort=$(kubectl get services kubernetes-dashboard -n kube-system -o jsonpath='{.spec.ports[0].nodePort}')
 
# Get token
dashToken=$(kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | awk '/^kubernetes-dashboard-token-/{print $1}') | awk '$1=="token:"{print $2}')
 
echo
echo
echo "Use your browser to connect to the Kubernetes Master on TCP/"$nodePort
echo
echo "Once connected, use the following token to authenticate:"
echo
echo $dashToken