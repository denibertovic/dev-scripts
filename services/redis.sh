#!/bin/bash

REDIS_LOCAL_PORT=6379

# FIXME : Add persisting
# DATA_DIR=$PROJECT_ROOT/__data

REDIS_CONTAINER_NAME=$PROJECT_NAME-REDIS

docker run -name $REDIS_CONTAINER_NAME  -d -p $REDIS_LOCAL_PORT denibertovic/redis:latest /usr/local/bin/start_redis.sh

REDIS_PORT=$(docker port $REDIS_CONTAINER_NAME $REDIS_LOCAL_PORT | \
    python -c 'import sys;obj=sys.stdin.read();print obj.split(":")[1].strip()')
