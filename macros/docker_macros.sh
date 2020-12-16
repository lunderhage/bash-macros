#!/bin/bash

# Being member in the docker group effectively makes you
# root on the docker host. Better do like this instead.
alias docker="sudo -E docker"

alias docker-compose="sudo -E docker-compose"

export MACHINE_STORAGE_PATH=~/.docker/machine

# Yes, you should avoid unprotected client certs do docker
# hosts as those are tickets to root.
alias docker-machine="sudo -E /usr/local/bin/docker-machine"

# Make it easier to change/reset docker host wthout 
# fiddling with eval.
alias docker-machine-env="_docker_machine_env"
alias docker-machine-reset="_docker_machine_reset"

_docker_machine_env() {
    eval $(docker-machine env $1)
}

_docker_machine_reset() {
    eval $(docker-machine env --unset)
}
