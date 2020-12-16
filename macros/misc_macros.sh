#!/bin/bash

# Easily update Ubuntu (or any other apt based distro).
alias update-ubuntu="sudo bash -c 'apt-get update && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get autoclean'"

# How often don't we wonder what it really is?
alias whatismyip="host myip.opendns.com resolver1.opendns.com | grep \"has address\" | cut -d ' ' -f 4"

# Want to be sure all your chromecasts are updated?
function update-chromecast() {
	ALL_CHROMECASTS=$(avahi-browse -ptr -d local _googlecast._tcp | grep -v "Google Cast Group" | grep -oE '([0-9]+\.){3}[0-9]+;[0-9]+')

	for CHROMECAST in ${ALL_CHROMECASTS}; do
		ADDR=$(echo ${CHROMECAST} | cut -d ';' -f 1)
		PORT=$(echo ${CHROMECAST} | cut -d ';' -f 2)
		echo "Updating ${ADDR}:${PORT}..."

		curl -sfk -X POST -H 'Content-Type: application/json' -d '{"params": "ota foreground"}' https://${ADDR}:${PORT}/setup/reboot -v
	done
	echo "Done updating chromecasts."
}
