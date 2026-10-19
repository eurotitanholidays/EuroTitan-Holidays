FASTER SITE: SELF-HOST PHOTOS + FONTS (one-time, ~2 minutes, on your PC)
1. Unzip this package into one folder.
2. Windows: open PowerShell in that folder and run:
     powershell -ExecutionPolicy Bypass -File download-assets.ps1
   Mac/Linux: run  sh download-assets.sh  (photos) in that folder.
   This creates the "images" and "fonts" folders.
3. Upload EVERYTHING (HTML files + images/ + fonts/) to the GitHub repo root.
Until you do step 2-3 the site still works: it falls back to Unsplash / Google Fonts automatically, just slower.
