BUCKET_NAME="jijo-archive"
FOLDER_PREFIX="Inauguration AGFS 2022/"

aws s3api list-objects-v2 \
  --bucket "$BUCKET_NAME" \
  --prefix "$FOLDER_PREFIX" \
  --query "Contents[].Key" \
  --output text | tr '\t' '\n' | while read key; do
  storage_class=$(aws s3api head-object \
    --bucket "$BUCKET_NAME" \
    --key "$key" \
    --query "StorageClass" \
    --output text 2>/dev/null)
  echo "$key => $storage_class"
done | sort | uniq -c
