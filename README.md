# Clipboard Screenshot Uploaders (Wayland / KDE Plasma)

**README.md got written by AI because i am bad in stuff like that :(**

A collection of simple Bash scripts to take whatever image is in your clipboard and upload it straight to Nextcloud or Catbox.moe with a single hotkey press. 

### Why this exists
If you're using KDE Plasma 6 on Wayland, you've probably ran into issues with Spectacle or other screenshot tools getting stuck, uploading cached images, or failing silently in the background. 

Instead of fighting Wayland permissions or Spectacle bugs, these scripts bypass the headache completely: you take a screenshot normally, press a shortcut, and instantly get a share link copied to your clipboard.

---

## Features

* Zero clutter: Images are temporarily created in /tmp/ and instantly deleted right after the upload finishes.
* Readable filenames: No weird string hashes. Screenshots use clean names like Screenshot_from_2026-08-18_at_15-30-45.png.
* Tool agnostic: Works with Spectacle, Grimblast, Flameshot, or literally just right-clicking an image anywhere and choosing Copy Image.
* Desktop alerts: Gives you a native system notification when the upload succeeds (or if your clipboard was empty).
* Built for Wayland: Native integration using wl-clipboard.

---

## Prerequisites

You just need wl-clipboard (to read/write the clipboard under Wayland) and curl.

Arch Linux / CachyOS:
```bash
sudo pacman -S wl-clipboard curl
```

Ubuntu / Debian:
```bash
sudo apt install wl-clipboard curl
```

---

## Quick Setup

1. Grab the repo:
   ```bash
   git clone https://github.com/xxApfelsaft/kde-clipboard-uploader.git
   cd kde-clipboard-uploader
   ```

2. Make the scripts executable:
   ```bash
   chmod +x nc_clipboarduploader.sh catbox_clipboarduploader.sh
   ```

3. Move them somewhere in your $PATH (recommended):
   ```bash
   mkdir -p ~/.local/bin
   cp nc_clipboarduploader.sh catbox_clipboarduploader.sh ~/.local/bin/
   ```

---

## Configuration

### 1. Nextcloud Uploader (nc_clipboarduploader.sh)

Open nc_clipboarduploader.sh in your text editor and pop in your Nextcloud details:

```bash
NC_DOMAIN="https://your-nextcloud-domain.com"   # Nextcloud URL (no trailing slash)
NC_USER="your_username"
NC_PASS="your_app_password"                       # Strongly recommend creating an App Password!
NC_FOLDER="Screenshots"                          # Target folder (must already exist in Nextcloud)
```

---

### 2. Catbox Uploader (catbox_clipboarduploader.sh)

Catbox just works out of the box—no account or login required!

If you want the uploads linked to your personal Catbox account, open catbox_clipboarduploader.sh and set your hash:

```bash
USER_HASH="your_catbox_user_hash"                # Optional (leave empty for anonymous uploads)
```

---

## Adding the Hotkey in KDE Plasma

The easiest way to use this is binding the script to a key like PageDown or Super+Shift+U:

1. Go to System Settings -> Keyboard -> Shortcuts.
2. Click Add New -> Command at the very bottom.
3. Paste the script path:
   ```bash
   /home/YOUR_USERNAME/.local/bin/nc_clipboarduploader.sh
   # OR
   /home/YOUR_USERNAME/.local/bin/catbox_clipboarduploader.sh
   ```
4. Press your hotkey (e.g. PageDown).
5. Hit Apply.

---

## How to use it

1. Take a screenshot or copy any image to your clipboard.
2. Press PageDown.
3. Hit Ctrl+V to drop your fresh link into Discord, Reddit, Matrix, or wherever!

---

## License

MIT. Do whatever you want with it!
