echo "Creating DB admin user..." && echo
  local users=$(mysql -s -e "SELECT count(User) FROM mysql.user WHERE User='$1'")
	echo $users
  if [[ $users == 0 ]]; then
    echo "=> Creating MariaDB user '$1' with '$2' password."
    mysql -uroot -e "CREATE USER '$1'@'%' IDENTIFIED BY '$2'"
  else
    echo "=> User '$1' exists, updating its password to '$2'"
    mysql -uroot -e "SET PASSWORD FOR '$1'@'%' = PASSWORD('$2')"
  fi;

  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO '$1'@'%' WITH GRANT OPTION"

  echo "========================================================================"
  echo "    You can now connect to this MariaDB Server using:                   "
  echo "    mysql -u$1 -p$2 -h<host>                      "
  echo "                                                                        "
  echo "    For security reasons, you might want to change the above password.  "
  echo "    The 'root' user has no password but only allows local connections   "
  echo "========================================================================"
