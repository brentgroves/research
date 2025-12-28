#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "boto3",
# ]
# ///
import boto3
import sys
import os
from datetime import datetime


def print_to_stdout(*a):
    print(os.path.basename(__file__)+':',*a, file = sys.stdout)


def print_to_stderr(*a):
    print(os.path.basename(__file__)+':',*a, file = sys.stderr)

def main():
  try:
    start_time = datetime.now()
    end_time = datetime.now()

    current_time = start_time.strftime("%H:%M:%S")
    print_to_stdout(f"Start Time: {current_time=}")

    # Replace with your Ceph RGW endpoint, access key, and secret key
    endpoint_url = 'http://10.188.50.201:80' 
    access_key = 'foo'
    secret_key = 'bar'

    s3_client = boto3.client(
        's3',
        endpoint_url=endpoint_url,
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key
    )
    print_to_stdout(f"After boto3.client()")

    response = s3_client.list_buckets()

    print("Buckets:")
    for bucket in response['Buckets']:
        print(f"  {bucket['Name']} - Created: {bucket['CreationDate']}")
  except ValueError as ve:
    return str(ve)

if __name__ == "__main__":
    sys.exit(main())