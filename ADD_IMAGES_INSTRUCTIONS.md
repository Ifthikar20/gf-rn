# How to Add Images to Asset Catalog

The images `women-cudly-1` through `women-cudly-7` are being referenced in the code but aren't properly added to the Xcode Asset Catalog.

## Quick Fix Instructions

1. **Open Xcode**
2. **Click on `Assets.xcassets`** in the Project Navigator (left sidebar)
3. **Select all your `women-cudly-*.png` files** in Finder from:
   ```
   /Users/ifthikaraliseyed/Desktop/gf-rn/gf-rn/GreatFeelSwiftUI/GreatFeelSwiftUI/Assets.xcassets/
   ```
4. **Drag and drop** them into the Xcode Asset Catalog window
5. Xcode will automatically create proper image sets for each file
6. **Clean Build Folder**: Product → Clean Build Folder (Cmd + Shift + K)
7. **Rebuild**: Product → Build (Cmd + B)

## What This Does

When you drag images into the Asset Catalog through Xcode, it creates this structure:
```
Assets.xcassets/
  ├── women-cudly-1.imageset/
  │   ├── Contents.json
  │   └── women-cudly-1.png
  ├── women-cudly-2.imageset/
  │   ├── Contents.json
  │   └── women-cudly-2.png
  └── ... (and so on)
```

## Current Issue

Right now, the PNG files are just sitting in the `Assets.xcassets` folder without the proper `.imageset` structure, so Xcode can't find them.

## After Adding Images

The errors should disappear and the images will display properly in:
- Goals screen (Goal.swift references them)
- Meditation sessions (Meditation.swift references them)

Delete this file after you've added the images successfully.
