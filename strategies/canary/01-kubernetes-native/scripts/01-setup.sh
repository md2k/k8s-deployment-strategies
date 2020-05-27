#!/bin/bash
printf "\n..Setup - Initial Stable Deployment..\n"

instance_count=$1
namespace=$2

# accept parameter for number of instances (default 10)
if [[ -z "$1" ]]; # or [ $# -eq 0 ]
  then        
    read -p "Required Number of Instances (default is 10): "
    instance_count=${REPLY:-10}
fi

if [[ -z "$2" ]]; 
  then        
    read -p "Target Namespace (default is canary-native) : "
    namespace=${REPLY:-"canary-native"}
fi

# delete namespace if exists
printf "\n...deleting $namespace namespace if it already exists\n"
kubectl delete ns $namespace

# create namesapce
printf "\n...creating $namespace namespace\n"
kubectl create ns $namespace

# deploy manifests
printf "\n...creating deployment for deployment.yaml\n"
kubectl apply -f ../manifests/deployment.yaml -n $namespace

printf "\n...scaling deployment to $instance_count\n"
kubectl scale --replicas=$instance_count deployment/myapp -n $namespace

printf "\n...creating a service\n"
kubectl apply -f ../manifests/service.yaml -n $namespace

# printf "\n...creating a service monitor\n"
# kubectl apply -f ../manifests/servicemonitor.yaml -n $namespace 

printf "\n...setting up fortio pod\n"
kubectl apply -f ../manifests/fortio.yaml -n $namespace

printf "\n...complete\n"

