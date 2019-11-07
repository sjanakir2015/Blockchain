#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/.build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=mychannel
export COMPOSE_PROJECT_NAME=fabric

set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yaml down
docker container list
docker container prune -f
docker-compose -f docker-compose.yaml up -d orderer.example.com peer0.org1.example.com peer0.org2.example.com peer0.org3.example.com peer0.org4.example.com cli
docker ps -a --format  'table {{.Names}} \t {{.Status}} \t {{.Ports}}'

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel, CHANNEL_NAME
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c ${CHANNEL_NAME} -f /etc/hyperledger/configtx/${CHANNEL_NAME}.tx

# Join peer0.org1.example.com to the channel.
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b ${CHANNEL_NAME}.block

# check if peer0.org1.example.com joined the channel 
docker exec  -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel list 

# Now, for org2
# fetch the channel block 
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME}  -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer0.org2.example.com peer channel fetch oldest ${CHANNEL_NAME}.block -o orderer.example.com:7050  --channelID ${CHANNEL_NAME}

# Join peer0.org2.example.com to the channel.
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer0.org2.example.com peer channel join -b ${CHANNEL_NAME}.block

# check if peer0.org2.example.com joined the channel 
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org2MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org2.example.com/msp" peer0.org2.example.com peer channel list 

# Now, for org3
# fetch the channel block 
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org3.example.com/msp" peer0.org3.example.com peer channel fetch oldest ${CHANNEL_NAME}.block -o orderer.example.com:7050  --channelID ${CHANNEL_NAME}

# Join peer0.org3.example.com to the channel.
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org3.example.com/msp" peer0.org3.example.com peer channel join -b ${CHANNEL_NAME}.block

# check if peer0.org3.example.com joined the channel 
docker exec  -e "CORE_PEER_LOCALMSPID=Org3MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org3.example.com/msp" peer0.org3.example.com peer channel list 

# Now, for org4
# fetch the channel block 
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org4MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org4.example.com/msp" peer0.org4.example.com peer channel fetch oldest ${CHANNEL_NAME}.block -o orderer.example.com:7050  --channelID ${CHANNEL_NAME}

# Join peer0.org4.example.com to the channel.
docker exec -e "CHANNEL_NAME="${CHANNEL_NAME} -e "CORE_PEER_LOCALMSPID=Org4MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org4.example.com/msp" peer0.org4.example.com peer channel join -b ${CHANNEL_NAME}.block

# check if peer0.org4.example.com joined the channel 
docker exec  -e "CORE_PEER_LOCALMSPID=Org4MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org4.example.com/msp" peer0.org4.example.com peer channel list 


