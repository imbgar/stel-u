import logging 
import os 
import base64

import boto3
from botocore.exceptions import ClientError

def encrypt_file(kms_client, key_id, in_file_name, out_blob_name):
  try:
    with open(in_file_name, 'rb') as in_file:
      cipher_text_blob = kms_client.encrypt(KeyId=key_id, Plaintext=in_file.read())["CiphertextBlob"]
    with open(out_blob_name, 'wb') as out_file:
      out_file.write(cipher_text_blob)
  except ClientError as e:
    logging.error(e)
  finally:
    logging.info("Encrypted file successfully.")

def decrypt_file(kms_client, in_file_name, out_file_name):
  try:
    with open(in_file_name, 'rb') as in_file:
      plain_text = kms_client.decrypt(CiphertextBlob=in_file.read())["Plaintext"]
    with open(out_file_name, 'w') as out_file:
      out_file.write(plain_text.decode())
  except ClientError as e:
    logging.error(e)
  finally:
    logging.info("Decrypted file successfully.")

def upload_file(s3_client, file_name, bucket, object_name=None):
  if object_name is None:
        object_name = file_name

  try:
    response = s3_client.upload_file(file_name, bucket, object_name)
  except ClientError as e:
    logging.error(e)
  finally:
    logging.info("Uploaded file successfully.")
    
def download_file(s3_client, bucket, object_name, out_file_name):
  try:
    s3_client.download_file(bucket, object_name, out_file_name)
  except ClientError as e:
    logging.error(e)
  finally:
    logging.info("Downloaded file successfully.")

if __name__ == "__main__":
  kms_client = boto3.client('kms')
  s3_client = boto3.client('s3')

  key_id = '<YOUR_KMS_KEY>'                            # KMS key to use
  in_file_name = 'secret.txt'                          # Plaintext input
  out_blob_name = "encrypted_blob.b64"                 # Encrypted blob
  out_from_s3_blob_name = "encrypted_blob_from_s3.b64" # Name for downloaded blob
  out_file_name = 'decrypted_secret.txt'               # Name for final decrypted file
  bucket = '<YOUR_BUCKET>'                             # Source Bucket

  logging.info("Encrypting file...")
  encrypt_file(kms_client, key_id, in_file_name, out_blob_name)

  logging.info("Uploading file to S3...")
  upload_file(s3_client, out_blob_name, bucket)

  logging.info("Downloading file from S3...")
  download_file(s3_client, bucket, out_blob_name, out_from_s3_blob_name)

  logging.info("Decrypting file...")
  decrypt_file(kms_client, out_from_s3_blob_name, out_file_name)

  logging.info("Completed process.")