from fastapi import FastAPI, File, UploadFile, HTTPException, Header
import boto3
import uuid
import os
from datetime import datetime
from typing import Optional

app = FastAPI()

# AWS clients
s3 = boto3.client("s3", region_name=os.getenv("AWS_REGION"))
dynamodb = boto3.resource("dynamodb", region_name=os.getenv("AWS_REGION"))
sqs = boto3.client("sqs", region_name=os.getenv("AWS_REGION"))

# Environment variables
BUCKET_NAME = os.getenv("S3_BUCKET")
DYNAMO_TABLE_NAME = os.getenv("DYNAMODB_TABLE")
SQS_QUEUE_URL = os.getenv("SQS_QUEUE_URL")

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/upload")
async def upload_document(
    file: UploadFile = File(...),
    x_tenant_id: Optional[str] = Header(None)
):
    if not x_tenant_id:
        raise HTTPException(status_code=400, detail="Missing tenant ID")

    try:
        file_id = str(uuid.uuid4())
        timestamp = datetime.utcnow().isoformat()
        s3_key = f"{x_tenant_id}/{file_id}/{file.filename}"

        # Upload to S3
        s3.upload_fileobj(file.file, BUCKET_NAME, s3_key)

        # Store metadata in DynamoDB
        table = dynamodb.Table(DYNAMO_TABLE_NAME)
        table.put_item(Item={
            "document_id": file_id,
            "tenant_id": x_tenant_id,
            "filename": file.filename,
            "timestamp": timestamp,
            "s3_key": s3_key
        })

        # Send message to SQS
        sqs.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody="document_uploaded",
            MessageAttributes={
                "document_id": {
                    "DataType": "String",
                    "StringValue": file_id
                },
                "tenant_id": {
                    "DataType": "String",
                    "StringValue": x_tenant_id
                }
            }
        )

        return {"message": "Upload successful", "document_id": file_id}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
