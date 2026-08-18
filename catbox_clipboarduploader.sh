#!/bin/bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================
# Optional: Enter your Catbox User Hash if you want uploads tied to your account.
# Leave empty ("") for anonymous uploads.
USER_HASH=""

# 1. Check if an image is available in the clipboard
if ! wl-paste -t image/png > /dev/null 2>&1; then
    notify-send "Catbox Uploader" "No image found in your clipboard." -u critical
    echo "Error: Please copy or capture an image to your clipboard first."
    exit 1
fi

# 2. Generate a clean & readable filename
HUMAN_DATE=$(date +"%Y-%m-%d_at_%H-%M-%S")
FILENAME="Screenshot_from_${HUMAN_DATE}.png"
TMP_FILE="/tmp/${FILENAME}"

# 3. Extract the image from the clipboard
wl-paste -t image/png > "$TMP_FILE"

echo "Sending $FILENAME to Catbox..."

# 4. Upload file to Catbox API
if [ -n "$USER_HASH" ]; then
    UPLOAD_URL=$(curl -s -F "reqtype=fileupload" -F "userhash=$USER_HASH" -F "fileToUpload=@$TMP_FILE" https://catbox.moe/user/api.php)
else
    UPLOAD_URL=$(curl -s -F "reqtype=fileupload" -F "fileToUpload=@$TMP_FILE" https://catbox.moe/user/api.php)
fi

# Clean up local temporary file
rm -f "$TMP_FILE"

# 5. Check response and copy link
if [[ "$UPLOAD_URL" =~ ^https://files.catbox.moe/ ]]; then
    echo -n "$UPLOAD_URL" | wl-copy
    notify-send "Catbox Uploader" "Screenshot uploaded!\nDirect link is ready in your clipboard." -i dialog-information
    echo "Success! Link copied: $UPLOAD_URL"
else
    notify-send "Catbox Uploader" "Upload failed. Couldn't reach Catbox." -u critical
    echo "Error: Catbox response - $UPLOAD_URL"
    exit 1
fi
