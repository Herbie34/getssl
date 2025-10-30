#!/usr/bin/env bash
fulldomain="$1"
token="$2"

url=${VALUEDOMAIN_ENDPOINT:-https://api.value-domain.com/v1/}
apikey=${VALUEDOMAIN_APIKEY:-''}

root=$(echo "$fulldomain" | awk -F\. '{print $(NF-1) FS $NF}')

# Get DNS settings
results=$(curl -fsS -X GET "${url}domains/${root}/dns" -H 'Content-Type: application/json;charset=utf8' -H "Authorization: Bearer $apikey") || exit 1
ns_type=$(echo "$results" | jq -r '.results.ns_type')
records=$(echo "$results" | jq -r '.results.records' | grep -vF "txt _acme-challenge")
ttl=$(echo "$results" | jq -r '.results.ttl')

# Put DNS settings
records_to_change=$(echo "${records}
txt _acme-challenge.${fulldomain%."$root"} \"$token\"" | jq -Rs .)
payload="{
  \"ns_type\": \"$ns_type\",
  \"records\": $records_to_change,
  \"ttl\": $ttl
}"
curl -fsS -o /dev/null -X PUT "${url}domains/${root}/dns" -H 'Content-Type: application/json;charset=utf8' -H "Authorization: Bearer $apikey" --data "$payload"