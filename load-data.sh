#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Load sample data to the ElasticSearch Cluster on GKE -"
# "- ./expose.sh needs to run before the script runs         -"
# "- expose.sh ports forward the local TCP 9200 traffic to pyrios in the cloud -"
# "-                                                       -"
# "---------------------------------------------------------"

set -o errexit
set -o nounset
set -o pipefail


ROOT=$(dirname "${BASH_SOURCE[0]}")

# Load sample data from the Elasticesearch Tutorial
# https://www.elastic.co/guide/en/kibana/current/tutorial-load-dataset.html
# curl -o data/shakespeare.json \
  # https://download.elastic.co/demos/kibana/gettingstarted/shakespeare_6.0.json

# Load the index mapping
echo "Loading the index into the Elasticsearch cluster"
curl http://localhost:9200/shakespeare \
  -H "Content-Type: application/json" \
  -X PUT \
  -d @"$ROOT"/data/mappings.json

echo

echo "Loading the shakespeare data into the Elasticsearch cluster"
curl -s 'http://localhost:9200/shakespeare/doc/_bulk?pretty' \
   -H "Content-Type: application/x-ndjson" \
   -X POST \
   --data-binary @"$ROOT"/data/shakespeare_6.0.json \
   -o /dev/null


echo "Loading the account data into the Elasticsearch cluster"
curl -s 'http://localhost:9200/bank/account/_bulk?pretty' \
   -H "Content-Type: application/x-ndjson" \
   -X POST \
   --data-binary @"$ROOT"/data/accounts.json \
   -o /dev/null


echo "Loading the log data into the Elasticsearch cluster"
curl -s 'http://localhost:9200/bank/_bulk?pretty' \
   -H "Content-Type: application/x-ndjson" \
   -X POST \
   --data-binary @"$ROOT"/data/logs.jsonl \
   -o /dev/null
