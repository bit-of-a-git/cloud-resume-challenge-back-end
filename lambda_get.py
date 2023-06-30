import boto3
import json
import os
from decimal import Decimal

# Connect to DynamoDB
dynamodb = boto3.resource("dynamodb")

##### CHANGE THE BELOW TO OS.ENVIRON

# Avoids hardcoding the DynamoDB table name by getting it from an environment variable
hit_table_name = os.environ["DYNAMODB_COUNT_TABLE_NAME"]
ip_table_name = os.environ["DYNAMODB_IP_TABLE_NAME"]

hit_table = dynamodb.Table(hit_table_name)
ip_table = dynamodb.Table(ip_table_name)

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    
    # Get the current visitor count from the visitor table
    hit_response = hit_table.get_item(Key={"record_id": "0"})
    hit_count = hit_response["Item"]["hit_count"]

    hit_count += 1

    response = hit_table.put_item(Item={"record_id":"0", "hit_count": hit_count})

    # Scan the ip_addresses table to get the count of hashed IP addresses
    ip_count_response = ip_table.scan(Select='COUNT')
    hashed_ip_count = ip_count_response["Count"]

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*"
        },
        "body": json.dumps({
            "hit_count": hit_count,
            "hashed_ip_count": hashed_ip_count
        }, cls=DecimalEncoder)
    }