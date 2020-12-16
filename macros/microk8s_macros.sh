#!/bin/bash

alias microk8s='sudo microk8s'
alias microk8s-namespaces='microk8s kubectl get all --all-namespaces'

k8s_create_token() {
	token=$(microk8s kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
	microk8s kubectl -n kube-system describe secret $token
}
