#!/bin/bash
export CS_HOME=$(pwd)
echo $CS_HOME
# Creating configMap, PersitentVolume,PersistentVolumeClaim, Nodeport and StatefulSet service for  postgres database
kubectl delete cm configserver-config coreapp-config events-config fluent-bit-config imageprocessor-config infinispanserver-configuration postgres-configuration workflow-config

kubectl delete -f $CS_HOME/csview/coreapp-deployment.yaml
#kubectl delete -f $CS_HOME/csview/coreapp-pv.yaml
#kubectl delete -f $CS_HOME/csview/coreapp-config.yaml
#sleep 5
kubectl delete -f $CS_HOME/workflow/workflow-deployment.yaml
#kubectl delete -f $CS_HOME/workflow/workflow-pv.yaml
#kubectl delete -f $CS_HOME/workflow/workflow-config.yaml

kubectl delete -f $CS_HOME/events/events-deployment.yaml
#kubectl delete -f $CS_HOME/events/events-pv.yaml
#kubectl delete -f $CS_HOME/events/events-config.yaml

#kubectl delete -f $CS_HOME/ediparser/ediparser-deployment.yaml
#kubectl delete -f $CS_HOME/ediparser/ediparser-pv.yaml
#kubectl delete -f $CS_HOME/ediparser/ediparser-config.yaml

kubectl delete -f $CS_HOME/configserver/configserver-deployment.yaml
#kubectl delete -f $CS_HOME/configserver/configserver-pv.yaml
#kubectl delete -f $CS_HOME/configserver/configserver-config.yaml


kubectl delete -f $CS_HOME/imageconverter/imageprocessor-deployment.yaml
#kubectl delete -f $CS_HOME/imageconverter/imageprocessor-pv.yaml
#kubectl delete -f $CS_HOME/imageconverter/imageprocessor-config.yaml

 
kubectl delete -f $CS_HOME/postgres/postgres-statefulset.yaml
kubectl delete -f $CS_HOME/postgres/postgres-nodeport.yaml
#kubectl delete -f $CS_HOME/postgres/postgres-pv.yaml
kubectl delete -f $CS_HOME/postgres/postgres-configmap.yaml
# Migration the database scripts using flyway job

kubectl delete -f $CS_HOME/flyway/flyway-job.yaml

kubectl delete -f $CS_HOME/RabbitMQ/rabbitmq-statefulset.yaml
#kubectl delete -f $CS_HOME/RabbitMQ/rabbitmq-pv.yaml

kubectl delete -f $CS_HOME/infinispanserver/infinispanserver-statefulset.yaml
#kubectl delete -f $CS_HOME/infinispanserver/infinispanserver-configmap.yaml 
#kubectl delete -f $CS_HOME/discoveryservice/

kubectl delete -f $CS_HOME/nfs-shared.yaml

#kubectl delete cm configserver-config coreapp-config ediparser-config events-config imageprocessor-config workflow-config

kubectl get pv,pvc,svc,cm


kubectl get pods -o wide
