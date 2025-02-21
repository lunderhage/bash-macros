#!/bin/bash

function select-instance() {
    aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | select(.State.Name == "running") | .InstanceId' | fzf
}

function get-console-output() {
    aws ec2 get-console-output --instance $(select-instance) --output text
}

function update-kubeconfig() {
    aws eks update-kubeconfig --name $(aws eks list-clusters | jq -r .clusters[])
}

function ecr-helm {
  REGISTRY_ID=$(aws ecr describe-registry | jq -r .registryId)
  aws ecr get-login-password \
    --region ${AWS_REGION} | helm registry login \
    --username AWS \
    --password-stdin ${REGISTRY_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
}
