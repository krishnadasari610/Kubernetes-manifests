#!/bin/bash

eval $(aws ecr get-login-password --region us-east-2 )

aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 585953033457.dkr.ecr.us-east-2.amazonaws.com

kubectl delete secret regcred

kubectl create secret docker-registry regcred  --docker-server=585953033457.dkr.ecr.us-east-2.amazonaws.com  --docker-username=AWS  --docker-password=$(aws ecr get-login-password) --namespace=default
