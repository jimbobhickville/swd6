#!/bin/bash -eux

apt-get install -y netcat-openbsd

# wait until both dbs are listening
until nc -z olddb 3306 && nc -z db 5432;
do
  echo "Waiting for db..."
  sleep 1
done;

pgloader -v mysql://root:swd6@olddb/swd6 postgresql://swd6:swd6@db/swd6
