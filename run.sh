#!/bin/bash


# GET CONFIG FIRST
if [ -f $PWD/`dirname $0`/../vars ]; then
    source $PWD/`dirname $0`/../vars
else
    echo "ERROR: Missing config file: vars"
    echo "See dev-scripts/vars.example and copy to your PROJECT_ROOT"
    exit 1;
fi

## Check various docker properties before continuing
source $PROJECT_ROOT/dev-scripts/checks/docker-checks.sh


############################# SERVICES LIST: ######################################
####################### RUNS ONLY THE SERVICES LISTED IN vars #####################

# POSTGRES
if [[ $REQUIRE_POSTGRES  && $REQUIRE_POSTGRES -eq 1 ]]; then \
    source $PROJECT_ROOT/dev-scripts/services/postgres.sh
    echo "Started container: $POSTGRES_CONTAINER_NAME"
fi

# REDIS
if [[ $REQUIRE_REDIS  && $REQUIRE_REDIS -eq 1 ]]; then \
    source $PROJECT_ROOT/dev-scripts/services/redis.sh
    echo "Started container: $REDIS_CONTAINER_NAME"
fi

# MEMCACHED
if [[ $REQUIRE_MEMCACHED  && $REQUIRE_MEMCACHED -eq 1 ]]; then \
    source $PROJECT_ROOT/dev-scripts/services/memcached.sh
    echo "Started container: $MEMCACHED_CONTAINER_NAME"
fi

############################# END SERVICES LIST ###################################


############################### CLEANUPS ##########################################

cleanup() {
    if [[ $REQUIRE_POSTGRES  && $REQUIRE_POSTGRES -eq 1 ]]; then
        echo 'STOPPING: ';
        docker stop -t 1 $POSTGRES_CONTAINER_NAME;
        echo 'CLEANING UP: ';
        docker rm $POSTGRES_CONTAINER_NAME;
    fi

    if [[ $REQUIRE_REDIS  && $REQUIRE_REDIS -eq 1 ]]; then \
        echo 'STOPPING: '
        docker stop -t 1 $REDIS_CONTAINER_NAME;
        echo 'CLEANING UP: '
        docker rm $REDIS_CONTAINER_NAME;
    fi

    if [[ $REQUIRE_MEMCACHED  && $REQUIRE_MEMCACHED -eq 1 ]]; then \
        echo 'STOPPING: '
        docker stop -t 1 $MEMCACHED_CONTAINER_NAME;
        echo 'CLEANING UP: '
        docker rm $MEMCACHED_CONTAINER_NAME;
    fi
    exit 0;
}


trap cleanup EXIT

############################### END CLEANUPS ######################################


# START APP SERVER
$PROJECT_ROOT/dev-scripts/appservers/$APPSERVER
