import json
import boto3

def lambda_handler(event, context):

    data = json.loads(event["body"])

    dynamodb = boto3.resource('dynamodb')

    table = dynamodb.Table('bgar-Movies')

    print(f"Writing item with: {data}")
    response = table.put_item(
        Item={
            'movie_id': data["movie_id"],
            'genre': data["genre"],
            'rating': data["rating"]
        }
    )

    response = {'statusCode': 200,
    'body': json.dumps(response)}

    return response