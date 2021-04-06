#!/bin/sh

# DEBIAN BASED - for other distros changes might be needed

SUBNET="192.168.111.0"
MASK="255.255.255.0"
LOG_FILE="/var/log/ntp.log"

check_for_root() {
	[ "$(id -u)" -ne 0 ] && \
	printf '\nThis script must be run by root.\n\n' && exit 1

	cat <<-HEADER
	Host:          $(hostname)
	Time at start: $(date)
	HEADER
}

install_service() {
	apt-get install ntp -y >/dev/null 2>&1
}

update_conf() {
	# allow the server to remain a valid \
	# time server to its NTP clients
	printf "\ntos orphan 15\n\
restrict $1 mask $2 nomodify notrap\n\
logfile $3\n" >> /etc/ntp.conf
}

start_service() {
	systemctl start ntp
}

check_for_root && [ $? -eq 1 ] && exit 1
install_service &&\
update_conf ${SUBNET} ${MASK} ${LOG_FILE} &&\
start_service &&\
exit 0 || exit 2
