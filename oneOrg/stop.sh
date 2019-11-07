#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export COMPOSE_PROJECT_NAME=fabric

set -ev

docker-compose -f docker-compose.yml down
docker container list 
docker container prune -f 

