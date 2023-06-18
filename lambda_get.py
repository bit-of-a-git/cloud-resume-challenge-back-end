import boto3
import json
import os
from decimal import Decimal

# Connect to DynamoDB
dynamodb = boto3.resource("dynamodb")

# Avoids hardcoding the DynamoDB table name by getting it from an environment variable
table_name = os.environ["DYNAMODB_TABLE_NAME"]

table = dynamodb.Table(table_name)

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return float(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    
    # Get the current visitor count
    response = table.get_item(Key={"record_id":"0"})

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
        },
        "body": json.dumps((response["Item"]["visitor_count"]), cls=DecimalEncoder)
    }