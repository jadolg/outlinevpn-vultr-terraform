#!/bin/bash

apt update && apt install docker.io fail2ban -y

bash -c "$(wget -qO- https://raw.githubusercontent.com/Jigsaw-Code/outline-server/master/src/server_manager/install_scripts/install_server.sh)" > /var/log/outline-install.log
grep "apiUrl" /var/log/outline-install.log >> /tmp/outline-install-details.txt
