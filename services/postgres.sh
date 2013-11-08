#!/bin/bash


##################################################################################################
# WARNING: Postgres Docker images provided are only for local DEV environments and under no      #
# circumstances should they be used in production. This is because of the following line in      #
# pg_hba.conf:                                                                                   #
#                                                                                                #
# host all all 0.0.0.0/0 trust                                                                   #
#                                                                                                #
# which allows connections to the database without asking for a password.                        #
# This is so we can easily connect to the db with the postgres user and create our               #
# dev databases and/or users.                                                                    #
##################################################################################################

DATA_DIR=$PROJECT_ROOT/__data
POSTGRES_VERSION=9.3
POSTGRES_LOCAL_PORT=5432

POSTGRES_CONTAINER_NAME=$PROJECT_NAME-POSTGRES

## create new __data dir or use existing one
## and start container
if [ ! -d $DATA_DIR/postgresql ]; then \
    echo 'Preparing Postgres persistent data storage...'; \
    mkdir -p $DATA_DIR; \
    docker run -v $DATA_DIR:/tmp/__data -i -t \
        denibertovic/postgres:$POSTGRES_VERSION\
        /bin/bash -c "cp -rp var/lib/postgresql /tmp/__data"; \
fi
echo "Persistent data storage found.";
echo "Starting postgres...";
docker run -name $POSTGRES_CONTAINER_NAME -v $DATA_DIR/postgresql:/var/lib/postgresql -d -p $POSTGRES_LOCAL_PORT \
    denibertovic/postgres:$POSTGRES_VERSION /usr/local/bin/start_postgres.sh;

POSTGRES_PORT=$(docker port $POSTGRES_CONTAINER_NAME $POSTGRES_LOCAL_PORT | \
    python -c 'import sys;obj=sys.stdin.read();print obj.split(":")[1].strip()')

## let the database boot up
## FIXME: need a smarter way to do this
sleep 3;

## CREATE USER AND DB IF THEY DON'T ALREADY EXIST
PGPORT=$POSTGRES_PORT $PROJECT_ROOT/dev-scripts/helpers/init_postgres.sh good_db good_user gooduser123


export POSTGRES_CONNECTION_STRING="postgres://good_user:gooduser123@localhost:$POSTGRES_PORT/good_db"
echo "Postgres connection string:"
echo $POSTGRES_CONNECTION_STRING;
