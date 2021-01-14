#!/bin/bash
set -e

MACROS_DIR=$(pwd)/macros

echo << EOF >> ${HOME}/.bash_aliases
### Source Lunderhage's Macros ###
for file in ${MACROS_DIR}/*.sh; do
	source "$file"
done
### End of Lunderhage's Macros ###
EOF
