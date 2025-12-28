#!/bin/bash

####
# Upload one file to configured S3 bucket
#
# 20240418 gbh
#
# Accepts the path to the file to upload as its only command-line argument. Uploads
# to the S3 bucket configured in the 'Configuration' block below.
#
# Requires curl, awk, file
#
# usage:
# put_to_s3.sh /path/to/file

####
# Configuration
#

# S3 bucket and location
bucket="<your bucket name>"
location="<your aws region, ie. us-west-2>"

# AWS credentials
aws_access_key_id="<your aws access key id>"
aws_secret_access_key="<your aws secret key id>"

# Do not edit below.

####
# Calculated values

# file parts
file_path=$1
file_name=`basename "$file_path"`

# Content-Type header for curl
file_mime=`file --mime-type ${file_path}`
content_type=`echo $file_mime | awk -F ": " '{print $2}'`

# Date in format for header and signature
date_value=`date -R`

# Destination file path on s3 bucket
s3_resource="/${bucket}/`basename \"$file_path\"`"

#### FUNCTION BEGIN
# Build AWS signature for api call
# GLOBALS: 
# 	-
# ARGUMENTS: 
# 	s3_resource
# 	content_type
# 	date_value
# 	aws_secret_access_key
# OUTPUTS: 
# 	null
# RETURN: 
# 	String. The signature
### FUNCTION END
function build_sig() {
	s3_resource=$1
	content_type=$2
	date_value=$3
	aws_secret_access_key=$4

	string_to_sign="PUT\n\n${content_type}\n${date_value}\n${s3_resource}"
	signature=`echo -en ${string_to_sign} | openssl sha1 -hmac ${aws_secret_access_key} -binary | base64`

	echo "$signature"
}

#### FUNCTION BEGIN
# PUT file to S3 bucket
# GLOBALS: 
# 	-
# ARGUMENTS: 
# 	file_path
# 	bucket
# 	location
# 	date_value
# 	content_type
# 	aws_access_key_id
# 	signature
# OUTPUTS: 
# 	null
# RETURN: 
# 	void
### FUNCTION END
function put_s3() {
	file_path=$1
	bucket=$2
	location=$3
	date_value=$4
	content_type=$5
	aws_access_key_id=$6
	signature=$7
	file_name=`basename "$file_path"`

	curl -s -X PUT -T "${file_path}" \
	  -H "Host: ${bucket}.s3.amazonaws.com" \
	  -H "Date: ${date_value}" \
	  -H "Content-Type: ${content_type}" \
	  -H "Authorization: AWS ${aws_access_key_id}:${signature}" \
	  https://${bucket}.s3-${location}.amazonaws.com/${file_name}
}

# entry point

# Build signature for this API call
signature=`build_sig "$s3_resource" "$content_type" "$date_value" "$aws_secret_access_key"`

# PUT the file to the s3 bucket
put_s3 "$file_path" "$bucket" "$location" "$date_value" "$content_type" "$aws_access_key_id" "$signature"

exit 0