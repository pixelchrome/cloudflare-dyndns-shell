#!/usr/bin/env sh

# Developer: Maik Ellerbrock <opensource@frapsoft.com>
#
# GitHub:  https://github.com/ellerbrock
# Twitter: https://twitter.com/frapsoft
# Docker:  https://hub.docker.com/u/ellerbrock
# Quay:    https://quay.io/user/ellerbrock

# Required Parameter
CF_EMAIL=""
CF_TOKEN=""
CF_ZONE_NAME=""
CF_DOMAIN_NAME=""

# Optional Parameter
EXTERNAL_IPv4=$(dig +short myip.opendns.com @resolver1.opendns.com)
EXTERNAL_IPv6=$(dig -6 +short myip.opendns.com aaaa @resolver1.ipv6-sandbox.opendns.com)

# we get them automatically for you
CF_ZONEID=""
CF_DOMAINIDv4=""
CF_DOMAINIDv6=""

function getZoneID() {
  CF_ZONEID=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones?name=${CF_ZONE_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" | \
    jq -r .result[0].id)
}

function getDomainIDv4() {
  CF_DOMAINIDv4=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records?name=${CF_DOMAIN_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" | \
  jq -r .result[0].id)
}

function updateDomainv4() {
  curl -s \
    -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records/${CF_DOMAINIDv4}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${CF_DOMAIN_NAME}'","content":"'${EXTERNAL_IPv4}'","ttl":1,"proxied":false}'
}

function getDomainIDv6() {
  CF_DOMAINIDv6=$(curl -s \
    -X GET "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records?name=${CF_DOMAIN_NAME}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" | \
  jq -r .result[1].id)
}

function updateDomainv6() {
  curl -s \
    -X PUT "https://api.cloudflare.com/client/v4/zones/${CF_ZONEID}/dns_records/${CF_DOMAINIDv6}" \
    -H "X-Auth-Email: ${CF_EMAIL}" \
    -H "X-Auth-Key: ${CF_TOKEN}" \
    -H "Content-Type: application/json" \
    --data '{"type":"AAAA","name":"'${CF_DOMAIN_NAME}'","content":"'${EXTERNAL_IPv6}'","ttl":1,"proxied":false}'
}

getZoneID
getDomainIDv4
updateDomainv4
getDomainIDv6
updateDomainv6
