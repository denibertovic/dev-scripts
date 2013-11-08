#!/bin/bash

## Create a database and user if they don't exist

if [ $# -ne 3 ]; then
 echo "Usage: ./init_postgres.sh db_name db_user db_password"
 exit 1;
fi

DBNAME=$1
DBUSER=$2
DBPASS=$3

# Parse psql output and determine if the given database already exists
db_exists=`psql -Upostgres -h localhost -p $PGPORT -c "select count(1) from pg_catalog.pg_database where datname='$DBNAME';" | awk 'NR==3'`


# create if it doesn't exists already
if [[ $db_exists -eq 0 ]] ; then
   # create the database, discard the output
   echo "Creating Postgres Database..."
   echo
   psql -Upostgres -h localhost -p $PGPORT -c "create database $DBNAME;" > /dev/null 2>&1
else
    echo "Postgres Database already exists. Skipping..."
    echo
fi


# Parse psql output if the given user/role already exists
user_exists=`psql -Upostgres -h localhost -p $PGPORT -c "select count(1) from pg_catalog.pg_user where usename='$DBUSER';" | awk 'NR==3'`

# create if user doesn't exist
if [[ $user_exists -eq 0 ]] ; then
    # create the user, discard the output
    echo "Creating Postgres User..."
    echo
    psql -Upostgres -h localhost -p $PGPORT -c "CREATE USER $DBUSER WITH PASSWORD '$DBPASS';" > /dev/null 2>&1
    psql -Upostgres -h localhost -p $PGPORT -c "GANT ALL ON DATABASE $DBNAME TO $DBUSER;" > /dev/null 2>&1
else
    echo "Postgres User already exists. Skipping..."
    echo
fi


# exit with success status
exit 0
