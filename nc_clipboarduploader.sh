#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
NC_DOMAIN="https://your-nextcloud-domain.com"   # No trailing slash
NC_USER="your_username"
NC_PASS="your_app_password"                       # App Password recommended
NC_FOLDER="Screenshots"                          # Target folder in Nextcloud

# ==============================================================================
# SCRIPT LOGIC
# ==============================================================================

# 1. Check if an image is available in the clipboard
if ! wl-paste -t image/png > /dev/null 2>&1; then
    notify-send "Nextcloud Uploader" "No image found in your clipboard." -u critical
    echo "Error: Please copy or capture an image to your clipboard first."
    exit 1
fi

# 2. Generate a clean, human-readable filename
HUMAN_DATE=$(date +"%Y-%m-%d_at_%H-%M-%S")
FILENAME="Screenshot_from_${HUMAN_DATE}.png"
TMP_FILE="/tmp/${FILENAME}"

# 3. Extract the image from the clipboard
wl-paste -t image/png > "$TMP_FILE"

echo "Uploading $FILENAME to Nextcloud..."

# 4. Upload file via WebDAV
UPLOAD_URL="$NC_DOMAIN/remote.php/dav/files/$NC_USER/$NC_FOLDER/$FILENAME"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -u "$NC_USER:$NC_PASS" -T "$TMP_FILE" "$UPLOAD_URL")

# Clean up local temporary file
rm -f "$TMP_FILE"

if [ "$HTTP_STATUS" -ne 201 ] && [ "$HTTP_STATUS" -ne 200 ] && [ "$HTTP_STATUS" -ne 204 ]; then
    notify-send "Nextcloud Uploader" "Upload failed. (Server returned HTTP $HTTP_STATUS)" -u critical
    echo "Error: Upload failed with status code $HTTP_STATUS"
    exit 1
fi

# 5. Request a public share link
SHARE_RESPONSE=$(curl -s -u "$NC_USER:$NC_PASS" \
  -H "OCS-APIRequest: true" \
  -X POST "$NC_DOMAIN/ocs/v1.php/apps/files_sharing/api/v1/shares" \
  -d path="/$NC_FOLDER/$FILENAME" \
  -d shareType=3)

# Extract share link
SHARE_URL=$(echo "$SHARE_RESPONSE" | grep -oP '(?<=<url>).*?(?=</url>)')

# 6. Copy link to clipboard & notify
if [ -n "$SHARE_URL" ]; then
    echo -n "$SHARE_URL" | wl-copy
    notify-send "Nextcloud Uploader" "Screenshot uploaded!\nShare link is ready in your clipboard." -i dialog-information
    echo "Success! Link copied: $SHARE_URL"
else
    notify-send "Nextcloud Uploader" "File uploaded, but couldn't create a share link." -u critical
    echo "Error: Share link generation failed."
fi
