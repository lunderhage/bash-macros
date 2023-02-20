#!/bin/bash

alias kube-tools-download='curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/{kubeadm,kubelet,kubectl}'

alias kubeconfig='export KUBECONFIG=$(ls -1 ~/.kube/kubeconfig.* | sort | fzf)'

install-kubectl() {
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  sudo mv kubectl /usr/local/bin/kubectl
  sudo chmod +x /usr/local/bin/kubectl
}

install-krew() {
  (
    set -x; cd "$(mktemp -d)" &&
    OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
    KREW="krew-${OS}_${ARCH}" &&
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
    tar zxvf "${KREW}.tar.gz" &&
    ./"${KREW}" install krew
    echo "PATH=\${KREW_ROOT:-\$HOME/.krew}/bin:\$PATH" >> ~/.bash_aliases
    export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
  )
}

install-kubens-kubectx() {
  kubectl krew install ctx
  kubectl krew install ns
}

# If we have krew, we want it in out path.
KREW_BIN_HOME=${HOME}/.krew/bin
if [ -e ${KREW_BIN_HOME} ]; then
    export PATH=${KREW_BIN_PATH}:${PATH}
fi

# Some K8s tool command completions.
K8S_TOOLS="kubectl helm flux velero"

for TOOL in ${K8S_TOOLS}; do
  if command -v ${TOOL} &> /dev/null; then
    source <(${TOOL} completion bash)
  fi
done

if command -v kubectl &> /dev/null; then
    alias k='kubectl'
    complete -F __start_kubectl k
fi
