cd /etc/apt
wget http://mirrors.163.com/.help/sources.list.lucid
mv sources.list sources.list.backup
mv sources.list.lucid sources.list
apt-get update
