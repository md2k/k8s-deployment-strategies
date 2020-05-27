#!/bin/bash

namespace=$1

if [[ -z "$1" ]]; 
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

helm install myapp stable/prometheus-operator -n $namespace

