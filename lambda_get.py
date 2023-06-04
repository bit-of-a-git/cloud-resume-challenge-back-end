import boto3
import json
from decimal import Decimal

# Connect to DynamoDB
dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("visitor_table")

class DecimalEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, Decimal):
            return str(o)
        return super(DecimalEncoder, self).default(o)

def lambda_handler(event, context):
    
    # Get the current visitor count
    response = table.get_item(Key={"record_id":"0"})

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json"
        },
        "body": json.dumps((response["Item"]["visitor_count"]), cls=DecimalEncoder)
    }