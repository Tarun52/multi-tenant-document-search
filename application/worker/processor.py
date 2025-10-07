import boto3
import os
import time
import json
import logging
from elasticsearch import Elasticsearch, RequestsHttpConnection
import redis
from urllib.parse import urlparse

logging.basicConfig(level=logging.INFO)

# AWS clients
sqs = boto3.client("sqs", region_name=os.getenv("AWS_REGION"))
s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION"))
dynamodb = boto3.resource("dynamodb", region_name=os.getenv("AWS_REGION"))

# ENV variables
QUEUE_URL = os.getenv("SQS_QUEUE_URL")
S3_BUCKET = os.getenv("S3_BUCKET")
DYNAMO_TABLE_NAME = os.getenv("DYNAMODB_TABLE")
OPENSEARCH_HOST = os.getenv("OPENSEARCH_HOST")
REDIS_HOST = os.getenv("REDIS_HOST")

# OpenSearch client
es = Elasticsearch(
    [OPENSEARCH_HOST],
    use_ssl=True,
    verify_certs=False,
    connection_class=RequestsHttpConnection
)

# Redis client
redis_client = redis.Redis(host=REDIS_HOST, port=6379, decode_responses=True)

def process_message(message):
    try:
        attrs = message.get("MessageAttributes", {})
        document_id = attrs["document_id"]["StringValue"]
        tenant_id = attrs["tenant_id"]["StringValue"]
        s3_key = attrs["s3_key"]["StringValue"]

        logging.info(f"Processing doc {document_id} for tenant {tenant_id}")

        # Download file from S3
        tmp_file = f"/tmp/{document_id}"
        s3.download_file(S3_BUCKET, s3_key, tmp_file)

        # Get metadata
        table = dynamodb.Table(DYNAMO_TABLE_NAME)
        metadata = table.get_item(Key={"document_id": document_id}).get("Item", {})

        # Fake parse for now (replace with real NLP/OCR etc.)
        parsed_text = f"Sample text extracted from {metadata.get('filename')}"

        # Index into OpenSearch
        index_name = f"tenant-{tenant_id}"
        es.index(index=index_name, id=document_id, body={
            "document_id": document_id,
            "tenant_id": tenant_id,
            "filename": metadata.get("filename"),
            "timestamp": metadata.get("timestamp"),
            "content": parsed_text
        })

        # Cache keywords (example only)
        keywords = parsed_text.split()[:5]
        for word in keywords:
            redis_client.sadd(f"autocomplete:{tenant_id}", word.lower())

        logging.info(f"Document {document_id} processed successfully")

    except Exception as e:
        logging.error(f"Error processing message: {e}")

def poll_queue():
    while True:
        response = sqs.receive_message(
            QueueUrl=QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=10,
            MessageAttributeNames=["All"]
        )

        messages = response.get("Messages", [])
        for msg in messages:
            process_message(msg)
            sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=msg["ReceiptHandle"])

        time.sleep(1)

if __name__ == "__main__":
    poll_queue()
