import boto3
import json
import os

# Connect to DynamoDB
dynamodb = boto3.resource("dynamodb")

# Avoids hardcoding the DynamoDB table name by getting it from an environment variable
table_name = os.environ["DYNAMODB_TABLE_NAME"]

table = dynamodb.Table(table_name)

def lambda_handler(event, context):
    
    # Get the current visitor count
    response = table.get_item(Key={"record_id":"0"})
    visitor_count = response["Item"]["visitor_count"]
    
    # Increment the visit count by 1
    visitor_count += 1
    
    # Update the visit count
    response = table.put_item(Item={"record_id":"0", "visitor_count": visitor_count})
    
    # Return the updated visit count

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
        },
        "body": json.dumps("Records added successfully.")
    }