#!/bin/bash
set -x
ACCESS_KEY="foo"
SECRET_KEY="bar"
# ACCESS_KEY="accesskey"
# SECRET_KEY="secret"

SERVICE="s3"
REGION="default"
ENDPOINT="micro11"
BUCKET="mybucket"
# ENDPOINT="s3-test.example.com"
# BUCKET="bucketname"

MYPATH="?policy"
TIMEDATE="$(date -u '+%Y%m%d')"
TIMEDATEISO="${TIMEDATE}T$(date -u '+%H%M%S')Z"

# Create sha256 hash in hex
function hash_sha256 {
  printf "${1}" | openssl dgst -sha256 |  sed "s/^.* //"
}

# Create sha256 hmac in hex
function hmac_sha256 {
  printf "{2}" | openssl dgst -sha256 -mac HMAC -macopt "${1}" | sed "s/^.* //"
}

PAYLOAD="$(printf "" | openssl dgst -sha256 |  sed 's/^.* //')"
CANONICAL_URI="/${BUCKET}${MYPATH}"
# CANONICAL_HEADERS="host:${ENDPOINT} x-amz-content-sha256:${PAYLOAD} x-amz-date:${TIMEDATEISO}"
CANONICAL_HEADERS="host:${ENDPOINT}
x-amz-content-sha256:${PAYLOAD}
x-amz-date:${TIMEDATEISO}"

SIGNED_HEADERS="host;x-amz-content-sha256;x-amz-date"
# CANONICAL_REQUEST="GET
# ${CANONICAL_URI}
# ${CANONICAL_HEADERS}
# ${SIGNED_HEADERS}
# ${PAYLOAD}"
CANONICAL_REQUEST="GET
${CANONICAL_URI}\n
${CANONICAL_HEADERS}\n
${SIGNED_HEADERS}\n
${PAYLOAD}"

# Create signature
function create_signature {
  stringToSign="AWS4-HMAC-SHA256\n${TIMEDATEISO}\n${TIMEDATE}/${REGION}/${SERVICE}/aws_request\n$(hash_sha256 "${CANONICAL_REQUEST}")"
  dateKey=$(hmac_sha256 key:"AWS4${SECRET_KEY}" "${TIMEDATE}")
  regionKey=$(hmac_sha256 hexkey:"${dateKey}" "${REGION}")
  serviceKey=$(hmac_sha256 hexkey:"${regionKey}" "${SERVICE}")
  signingKey=$(hmac_sha256 hexkey:"${serviceKey}" "aws4_request")

  printf "${stringToSign}" | openssl dgst -sha256 -mac HMAC -macopt hexkey:"${signingKey}" |  sed 's/(stdin)= //'
}

SIGNATURE="$(create_signature)"

AUTH_HEADER="\
AWS4-HMAC-SHA256 Credential=${ACCESS_KEY}/${TIMEDATE}/${REGION}/${SERVICE}/aws4_request, \
SignedHeaders=${SIGNED_HEADERS}, Signature=${SIGNATURE}"

curl -vvv "http://${ENDPOINT}${CANONICAL_URI}" \
    -H "Accept:" \
    -H "Authorization: ${AUTH_HEADER}" \
    -H "x-amz-content-sha256: ${PAYLOAD}" \
    -H "x-amz-date: ${TIMEDATEISO}" \

# curl -vvv "https://${ENDPOINT}${CANONICAL_URI}" \
#     -H "Accept:" \
#     -H "Authorization: ${AUTH_HEADER}" \
#     -H "x-amz-content-sha256: ${PAYLOAD}" \
#     -H "x-amz-date: ${TIMEDATEISO}" \
