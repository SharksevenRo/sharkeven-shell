if [ ! -z "$1" ]
then

    dist=$1
else
    dist='w'
fi
case $dist in
         w)
          cd $WORK_DIR
         ;;
         p)
           cd $PERSON_WORK_DIR
         ;;
         *)
           echo "Ignorant"
         ;;
 esac
