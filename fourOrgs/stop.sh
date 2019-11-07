#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export COMPOSE_PROJECT_NAME=fabric

set -e
docker ps -a --format  'table {{.Names}} \t {{.Status}} \t {{.Ports}}'
docker-compose -f docker-compose.yaml down
docker container prune -f
docker ps -a --format  'table {{.Names}} \t {{.Status}} \t {{.Ports}}'

