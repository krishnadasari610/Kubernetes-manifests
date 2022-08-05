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

