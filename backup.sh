#!/bin/bash

remote_server="www.hornet.technology"
remote_username="hornet"
remote_database="hornet"

ssh "$remote_username@$remote_server" "pg_dump -U $remote_username -h localhost -d $remote_database -f ~/hornet_dump.sql"

echo "Dump file generated on the remote server."

echo "Copying the dump file to local machine"

scp "$remote_username@$remote_server:~/hornet_dump.sql" .

echo "Stopping core-engine"

echo 'H0rnSt@r' | sudo -S systemctl stop core-engine.service 

echo "Dropping database hornet"

dropdb hornet 

echo "Creating database hornet"

createdb hornet

echo "Restoring the database backup"

psql -U hornet -d hornet < hornet_dump.sql 

echo "Reloading the Deamon"

echo 'H0rnSt@r' | sudo -S systemctl daemon-reload 

echo "Starting the core-engine" 

echo 'H0rnSt@r' | sudo -S systemctl start core-engine

echo "Operations completed"
