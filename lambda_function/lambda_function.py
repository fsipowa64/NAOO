import os
import boto3

# Initialize SNS client
sns = boto3.client('sns')

def lambda_handler(event, context):
    # Get SNS topic ARN from environment variable
    sns_topic_arn = os.environ['SNS_TOPIC_ARN']
    
    # Publish email message to SNS topic
    response = sns.publish(
        TopicArn=sns_topic_arn,
        Message='File Uploaded to S3 Successfully. Lambda function executed successfully.'
    )
    print("Email notification sent via SNS.")
    
    return {
        'statusCode': 200,
        'body': 'Email notification sent via SNS.'
    }
