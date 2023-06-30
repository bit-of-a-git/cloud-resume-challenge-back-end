import json
import boto3
import hashlib
import time
import os

dynamodb = boto3.resource('dynamodb')
table_name = os.environ["DYNAMODB_TABLE_NAME"]

# Common headers dictionary
headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*"
}

def lambda_handler(event, context):
    try:
        visitor_ip = event['requestContext']['identity']['sourceIp']
        
        hashed_ip = hash_ip_address(visitor_ip)
        
        table = dynamodb.Table(table_name)

        response = table.get_item(Key={'hashed_ip_address': hashed_ip})
        
        if 'Item' in response:
            # Item already exists, do not insert a duplicate
            return {
                'statusCode': 200,
                'headers': headers,
                'body': json.dumps({'message': 'IP address already exists'})
            }
        
        current_timestamp = int(time.time()) + 2678400  # Convert current datetime to epoch number + 1 month
        
        table.put_item(Item={'hashed_ip_address': hashed_ip, 'timestamp': current_timestamp})
        
        response = {
            'statusCode': 200,
            'headers': headers,
            'body': json.dumps({'message': 'Hashed IP address stored successfully'})
        }

    except Exception as e:
        response = {
            'statusCode': 500,
            'headers': headers,
            'body': json.dumps({'error': 'Failed to store hashed IP address'})
        }
    return response

def hash_ip_address(ip_address):
    # Hash the IP address using SHA-256 algorithm
    hashed_ip = hashlib.sha256(ip_address.encode()).hexdigest()
    return hashed_ip
