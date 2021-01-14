#!/bin/bash

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

