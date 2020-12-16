#!/bin/bash

alias kube-tools-download='curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/{kubeadm,kubelet,kubectl}'
