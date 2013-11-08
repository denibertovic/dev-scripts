# Dev scripts


Dev-scripts is a collection of helper scripts that utilizes [Docker](http://www.docker.io/)
to provide various Services in your local environment so that you can mimic your production
environment as closely as possible while you develop.


## Requirements

* Docker
* Python


## Installation

To use these scripts just clone the repo:

    git clone https://github.com/denibertovic/dev-scripts.git dev-scripts

And copy that to your project in your `PROJECT_ROOT` (see Configuration)

Alternatively if you wish to use this on many of your projects consider adding this
as a submodule to your project:

    git submodule add https://github.com/denibertovic/dev-scripts.git dev-scripts

For now it is expected that the folder is named `dev-scripts` and that it resides in `PROJECT_ROOT` (see Configuration)


## Configuration

Check out `vars.example` and copy them in your `PROJECT_ROOT`
Chose which services to enable.


## List of supported services

* Postgres (9.3)
* Redis
* Memcached


## Appservers

* Django app server


## How to use

After you have created your config just run `dev-scripts/run.sh`
The script will start all the required services and export `ENV` variables through which you can
access them.

After you shut down your app server the scripts make sure to cleanup all the containers. This means that 
all the containers are first stopped and then purged from the system.


## Postgres

You can access the Postgres database via the `POSTGRES_CONNECTION_STRING` environment variable.
The script initializes a database and user/password for you.

The Postgres database is persistent. It's data is being written to the host system in the PROJECT_ROOT/__data
folder, so when you restart the services your data will still be there.

To start over from scratch just delete that folder.


## REDIS

Redis (like all other services the scripts start) all listen on localhost but on a different port. Docker handles
port redirect to the specific port on the container.

You can access Redis via the `REDIS_PORT` environment variable.


## Memcached

Same as redis, you can access it via the `MEMCACHED_PORT` environment variable.


## Extending

You can easily add new app servers by creating a proper script in the `appservers` folder and
selecting it in your `vars` config.


## TODO

* Make Redis data persists (like postgres in the __data folder)
