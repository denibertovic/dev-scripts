DOCKER_VERSION=0.6.5

## check if docker installed
command -v docker >/dev/null 2>&1 || \
        { echo >&2 "Docker needs to be installed and on your PATH.  Aborting."; exit 1; }

## check if docker is the right version(ish)
if ! (docker version | grep -q $DOCKER_VERSION ) ; then \
        echo "ERROR: Wrong docker version. Required version: $DOCKER_VERSION"; \
        exit 1; \
fi

if ! ( grep -i -q "^docker.*`whoami`" /etc/group ); then \
    echo "ERROR! Are you in the 'docker' group? See: http://docs.docker.io/en/latest/use/basics/#why-sudo"; \
    exit 1;
fi
