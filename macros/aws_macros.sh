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

