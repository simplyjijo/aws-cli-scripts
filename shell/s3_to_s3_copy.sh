BUCKET_SOURCE="jijo-archive"
BUCKET_DEST="aaj-temp"
FOLDER_PREFIX="Inauguration AGFS 2022/"

total=0
copied=0
skipped_unrestored=0
skipped_error=0

echo "==== Starting File Transfer ===="

aws s3api list-objects-v2 \
  --bucket "$BUCKET_SOURCE" \
  --prefix "$FOLDER_PREFIX" \
  --query "Contents[].Key" \
  --output text | tr '\t' '\n' | while read key; do

  total=$((total+1))

  storage_class=$(aws s3api head-object \
    --bucket "$BUCKET_SOURCE" \
    --key "$key" \
    --query "StorageClass" \
    --output text 2>/dev/null)

  if [[ "$storage_class" == "GLACIER" || "$storage_class" == "GLACIER_FLEXIBLE_RETRIEVAL" || "$storage_class" == "DEEP_ARCHIVE" ]]; then
    restore=$(aws s3api head-object \
      --bucket "$BUCKET_SOURCE" \
      --key "$key" \
      --query "Restore" \
      --output text 2>/dev/null)

    if [[ "$restore" == *"ongoing-request=\"false\""* ]]; then
      echo "✅ Copied (restored from Glacier): $key"
      aws s3 cp "s3://$BUCKET_SOURCE/$key" "s3://$BUCKET_DEST/$key" --storage-class STANDARD && copied=$((copied+1)) || { echo "❌ Failed to copy: $key"; skipped_error=$((skipped_error+1)); }
    else
      echo "❌ Skipped (not restored): $key"
      skipped_unrestored=$((skipped_unrestored+1))
    fi

  else
    echo "✅ Copied (accessible): $key"
    aws s3 cp "s3://$BUCKET_SOURCE/$key" "s3://$BUCKET_DEST/$key" --storage-class STANDARD && copied=$((copied+1)) || { echo "❌ Failed to copy: $key"; skipped_error=$((skipped_error+1)); }
  fi
done

echo "==== Transfer Complete ===="
echo "📦 Total objects found:       $total"
echo "✅ Total objects copied:      $copied"
echo "❌ Skipped (not restored):    $skipped_unrestored"
echo "⚠️  Skipped (copy failed):     $skipped_error"
