#!/bin/bash

cat /root/private-network/Node/config.json | jq -r '.DNSBootstrapID = "<network>.svc.cluster.local"' > /root/private-network/node-config.json
cp /root/private-network/node-config.json /root/private-network/Node/config.json

cat /root/private-network/Primary/config.json | jq -r '.DNSBootstrapID = "<network>.svc.cluster.local"' > /root/private-network/primary-config.json
cp /root/private-network/primary-config.json /root/private-network/Primary/config.json

cat /root/private-network/Node/genesis.json | jq -r ".network = \"${NETWORK_NAME}\"" > /root/private-network/node-genesis.json
cp /root/private-network/node-genesis.json /root/private-network/Node/genesis.json

cat /root/private-network/Primary/genesis.json | jq -r ".network = \"${NETWORK_NAME}\"" > /root/private-network/primary-genesis.json
cp /root/private-network/primary-genesis.json /root/private-network/Primary/genesis.json

/bin/bash "$*"
