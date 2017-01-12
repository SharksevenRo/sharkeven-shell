kill -9 $(netstat -tlnp | grep 8086 | awk ‘{print $7}’ | awk -F ‘/’ ‘{print $1}’)
sudo lsb_release -a
lsof -i:80 | grep 'nginx'
chmod -Rvc 777 storage
