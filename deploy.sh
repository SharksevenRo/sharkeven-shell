echo "please enter commit info："

read msg

git pull origin master

git add .
git commit -a -m "$msg"
git push -u origin master
docker run -itd --volumes-from docker-volume-f6702803-4bba-41d8-8e0a-68f65a439724 -v /var/www/storage/codes/f6702803-4bba-41d8-8e0a-68f65a439724/docker2_shark:/root/workspace -m 512m  -p 6021:3000 -p 16970:8086 -p 6214:22  -h docker2 -w /root/workspace --name="gospel_project_docker2_shark"  gospel-nodejs:4.4.4
docker run -itd -e "VIRTUAL_HOST=localhost" --volumes-from docker-volume-f6702803-4bba-41d8-8e0a-68f65a439724 -v /var/www/storage/codes/f6702803-4bba-41d8-8e0a-68f65a439724/php_shark:/root/workspace -m 512m  -p 44136:3000 -p 16893:80 -p 16606:22  -h php -w /root/workspace --name="gospel_project_php_shark"  gospel-php:latest
docker run -itd --volumes-from docker-volume-f6702803-4bba-41d8-8e0a-68f65a439724 -v /var/www/storage/codes/f6702803-4bba-41d8-8e0a-68f65a439724/php-test_shark:/root/workspace -m 512m  -p 20698:3000 -p 39412:80 -p 28754:22  -h php-test -w /root/workspace --name="gospel_project_php-test_shark"  gospel-php:latest
docker run -itd --volumes-from docker-volume-459d17cc-8a0a-4dbc-b019-ea43dd43c982 -v /var/www/storage/codes/459d17cc-8a0a-4dbc-b019-ea43dd43c982/vue-f7_shark:/root/workspace -m 512m -p 4261:3000 -p 20200:8086 -p 40527:22  -h vue-f7 -w /root/workspace --name="gospel_project_vue-f7_shark"  gospel-vue-f7:latest
