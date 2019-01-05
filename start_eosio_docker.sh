#!/usr/bin/env bash
set -o errexit

# change to script's directory
cd "$(dirname "$0")/docker"

PROJ="$2"

if [ -e "data/initialized" ]
then
    script="./scripts/continue_blockchain.sh"
else
    script="./scripts/init_blockchain.sh"
fi


echo "=== run docker container from the eosio/eos-dev image ==="
docker run --rm --name "$PROJ" -d \
-p 7777:8888 -p 5555:5555 -p 9876:9876 \
--mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
--mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
--mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
-w "/opt/eosio/bin/" eosio/eos-dev:v1.4.2 /bin/bash -c "$script"

if [ "$1" != "--nolog" ]
then
    echo "=== follow $PROJ logs ==="
    docker logs "$PROJ" --follow
fi
