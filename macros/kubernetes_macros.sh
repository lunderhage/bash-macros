#!/bin/bash

alias kube-tools-download='curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/$(curl -sSL https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/{kubeadm,kubelet,kubectl}'

alias kubeconfig='export KUBECONFIG=$(ls -1 ~/.kube/kubeconfig.* | sort | fzf)'

install_kubectl() {
	curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /tmp/kubectl
	check_error $? "Error downloading kubectl."
	curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" -o /tmp/kubectl.sha256
	check_error $? "Error downloading checksum file."
	echo "$(</tmp/kubectl.sha256)  /tmp/kubectl" | sha256sum --check
	check_error $? "Checksum error."
	sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
	check_error $? "Installation error."
	kubectl version
	if [ $? -eq 0 ]; then
		echo "Installation successful."
		rm /tmp/kubectl /tmp/kubectl.sha256
	fi
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
		eval $(kubectl completion bash)
		alias k='kubectl'
    complete -F __start_kubectl k
fi

check_error() {
	err=$1
	msg=$2
	if [ $? -ne 0 ]; then
		echo "$msg"
		return 1
	fi
	return 0
}
