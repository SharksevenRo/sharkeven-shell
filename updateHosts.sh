bash -c "cd /tmp/hosts && git pull && rm /etc/hosts && mv /tmp/hosts/hosts /etc/ && /etc/init.d/networking restart "
ln -s ./updateHosts.sh /usr/local/bin/hosts
