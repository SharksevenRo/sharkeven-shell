#!/bin/bash
script=''
if [ ! -z "$2" ]
then

    dist=$2
else
    dist='mysql'
fi
case $dist in
         mysql)
          docker exec -it $1 bash -c 'mysql -u projects -pprojects'
         ;;
         work)
           $script='cd /root/workspace'
         ;;
         *)
           echo "Ignorant"
         ;;
 esac

