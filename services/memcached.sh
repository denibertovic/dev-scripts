#!/bin/bash

MEMCACHED_LOCAL_PORT=11211

# FIXME : Add persisting
# DATA_DIR=$PROJECT_ROOT/__data

MEMCACHED_CONTAINER_NAME=$PROJECT_NAME-MEMCACHED

docker run -name $MEMCACHED_CONTAINER_NAME -d -p $MEMCACHED_LOCAL_PORT denibertovic/memcached:latest /usr/local/bin/start_memcached.sh

MEMCACHED_PORT=$(docker port $MEMCACHED_CONTAINER_NAME $MEMCACHED_LOCAL_PORT | \
    python -c 'import sys;obj=sys.stdin.read();print obj.split(":")[1].strip()')
