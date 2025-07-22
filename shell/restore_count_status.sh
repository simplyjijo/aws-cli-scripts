BUCKET_NAME="jijo-archive"
FOLDER_PREFIX="Inauguration AGFS 2022/"

aws s3api list-objects-v2 \
  --bucket "$BUCKET_NAME" \
  --prefix "$FOLDER_PREFIX" \
  --query "Contents[].Key" \
  --output text | tr '\t' '\n' | while read key; do
  restore=$(aws s3api head-object \
    --bucket "$BUCKET_NAME" \
    --key "$key" \
    --query "Restore" \
    --output text 2>/dev/null)

  if [[ "$restore" == *"ongoing-request=\"false\""* ]]; then
    echo "restored"
  else
    echo "not_restored"
  fi
done | sort | uniq -c
