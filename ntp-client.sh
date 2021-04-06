#!/bin/sh

CONF_FILE="/etc/ntp.conf"
SERVER_IP="192.168.111.50"
LOG_FILE="/var/log/ntp.log"

check_for_root() {
        if [ "$(id -u)" -ne 0 ]; then
                printf 'This script must be run by root.\n\n' >&2
                exit 1
        fi

	cat <<-HEADER
	Host:          $(hostname)
	Time at start: $(date)
	
	HEADER
}

install_service() {
	apt-get install ntp -y 2>&1>/dev/null 
}

correct_leap() {
	update-leap /usr/share/zoneinfo/leap-seconds.list 1>/dev/null
}

update_conf() {
	sed -i "s/''/'-g'/" /etc/default/ntp
	cp  $1 ${1}.ORIG
	printf "#allow for time deviation\ntinker panic 0\n\n" > $1
	cat ${1}.ORIG >> $1
	printf "\n\nserver $2 iburst prefer\n\n
logfile ${3}\n\n" >> $1
}

start_service() {
	systemctl stop ntp
	ntpd -g -u ntp:ntp
	# shutdown ensures that config is applied at each start 
	kill -15 $(ps -ef | grep ntpd | awk '{print $2;exit}')
	systemctl start ntp
}

check_for_root && [ $? -eq 1 ] && exit 1
install_service &&\
correct_leap &&\
update_conf ${CONF_FILE} ${SERVER_IP} ${LOG_FILE} &&\
start_service && exit 0 || exit 2
