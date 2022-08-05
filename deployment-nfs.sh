#!/bin/bash
export REPOBASE="585953033457.dkr.ecr.us-east-2.amazonaws.com/s2/cs"
export CONFIG_SERVER_IMAGE=$REPOBASE/configservice:4.0.0-dev
export DISCOVERY_SERVICE_IMAGE=$REPOBASE/discoveryservice:4.0.0-dev
export GATEWAY_IMAGE=$REPOBASE/gateway:4.0.0-dev
export CSVIEW_IMAGE=$REPOBASE/core:4.0.0-dev
export WORKFLOW_IMAGE=$REPOBASE/workflow:4.0.0-dev
export EVENT_IMAGE=$REPOBASE/eventalarms:4.0.0-dev
export EDIPARSER_IMAGE=$REPOBASE/ediparserver:4.0.0-dev
export IMAGE_CONVERTER_IMAGE=$REPOBASE/imageprocessor:4.0.0-dev
export NFS_SERVER_IP="10.9.204.193"

sleep 10


#export CS_HOME=/home/dadockersetup/certscan-kubernetes/kubernetes
export CS_HOME=$(pwd)
echo $CS_HOME

#set -e
function kubectl_create() {
  if [[ ! -f $1 ]]
  then
    echo "$1 does not exist"
    exit 1
  fi

output=$(eval "cat <<EOF 
$(<$1) 
EOF" | kubectl create -f - 2>&1)

if [[ $? -ne 1 ]]
then
  echo $output
fi
}

function kubectl_delete() {
  if [[ ! -f $1 ]]
  then
    echo "$1 does not exist"
    exit 1
  fi

eval "cat <<EOF 
$(<$1) 
EOF" | kubectl delete -f -
}



function run() {
  if [[ $1 == "create" ]]
  then
    kubectl_create $2
  else
    kubectl_delete $2
  fi
}

kubectl delete secret regcred

kubectl create secret docker-registry regcred  --docker-server=585953033457.dkr.ecr.us-east-2.amazonaws.com  --docker-username=AWS  --docker-password=$(aws ecr get-login-password) --namespace=default


#Creating configMap, PersitentVolume,PersistentVolumeClaim, Nodeport and StatefulSet service for  postgres database

# applyKubectlConfig ./nfs-shared.yaml
# applyKubectlConfig 

run $1 ./nfs-shared.yaml

#kubectl apply -f $CS_HOME/nfs-shared.yaml
run $1 ./infinispanserver/infinispanserver-configmap.yaml
run $1 ./infinispanserver/infinispanserver-statefulset.yaml

run $1 ./postgres/postgres-configmap.yaml
run $1 ./postgres/postgres-nodeport.yaml
run $1 ./postgres/postgres-statefulset.yaml

sleep 10
run $1 ./flyway/flyway-job.yaml
sleep 10
run $1 ./RabbitMQ/rabbitmq-statefulset.yaml

kubectl create configmap configserver-config --from-file=$CS_HOME/../resources/properties/configserver_application.properties
run $1 ./configserver/configserver-deployment.yaml
sleep 5
kubectl create configmap events-config --from-file=$CS_HOME/../resources/properties/events_application.properties
run $1 ./events/events-deployment.yaml

#kubectl create configmap ediparser-config --from-file=$CS_HOME/ediparser/ediparser_application.properties
#kubectl apply -f $CS_HOME/ediparser/ediparser-deployment.yaml

kubectl create configmap imageprocessor-config --from-file=$CS_HOME/../resources/properties/imageprocessor_application.properties

run $1 ./imageconverter/imageprocessor-deployment.yaml


kubectl create configmap workflow-config --from-file=$CS_HOME/../resources/properties/workflow_application.properties

run $1 ./workflow/workflow-deployment.yaml


kubectl create configmap coreapp-config --from-file=$CS_HOME/../resources/properties/csview_application.properties --from-file=$CS_HOME/../resources/properties/csapplication-scsr.properties

run $1 ./csview/coreapp-deployment.yaml
 

#kubectl create configmap gateway-config --from-file=$CS_HOME/../resources/properties/gateway_application.properties 

#kubectl apply -f $CS_HOME/gateway/gateway.yaml
#kubectl apply -f $CS_HOME/gateway/gateway-pv.yaml

kubectl create configmap discovery-config --from-file=$CS_HOME/../resources/properties/discovery_service_application.properties 

run $1 ./discoveryservice/discovery-service.yaml

#run $1 ./discoveryservice/discovery-service-pv.yaml

run $1 ./logaggregation/elk-deploy.yaml

run $1 ./logaggregation/fluent-bit-cm.yaml

run $1 ./haproxy-ingress/haproxy-namespace.yaml
run $1 ./haproxy-ingress/haproxy-tls-secret.yaml
run $1 ./haproxy-ingress/haproxy-ingress-controller.yaml
run $1 ./haproxy-ingress/haproxy-ingress-rules.yaml

#run $1 ./prometheus-grafana-stack/manifests/setup/*.yaml
#run $1 ./prometheus-grafana-stack/manifests/*.yaml

kubectl get pv,pvc,cm,svc

kubectl get pods -o wide
