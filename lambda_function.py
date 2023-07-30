import boto3
import datetime

def get_greeting(current_hour):
    if current_hour < 12:
        return "Good morning"
    elif 12 <= current_hour < 18:
        return "Good afternoon"
    else:
        return "Good evening"


def lambda_handler(event,context):
        singapore_timezone = datetime.timezone(datetime.timedelta(hours=8))
        current_time = datetime.datetime.now(singapore_timezone).strftime("%Y-%m-%d %H:%M:%S")
        current_hour = datetime.datetime.now(singapore_timezone).hour
        
        
        greeting = f"{get_greeting(current_hour)}! The time now is {current_time}"
        
        return {
            'statusCode': 200,
            'body': greeting
        }