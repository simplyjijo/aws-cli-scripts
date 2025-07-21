aws s3api head-object \
  --bucket jijo-archive \
  --key "Inauguration AGFS 2022/DSC_0001.JPG" \
  --query "Restore" \
  --output text
