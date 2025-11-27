# How to Build and Run GreatFeel SwiftUI

## 🎯 Complete Step-by-Step Guide

This guide walks you through building and running the native SwiftUI app from scratch.

---

## ✅ Prerequisites

Before you start:
- ✓ **macOS** (Ventura 13.0 or later recommended)
- ✓ **Xcode 15.0+** installed from App Store
- ✓ **iOS 16.0+** simulator or device

---

## 🚀 Build & Run (Complete Process)

### **Step 1: Navigate to Project**

```bash
cd GreatFeelSwiftUI
```

You should see these folders:
- `GreatFeelSwiftUI/` (source code)
- `Info.plist`
- Various `.md` files

---

### **Step 2: Create Xcode Project**

#### **Option A: Manual Creation (Recommended)**

1. **Open Xcode**
   ```bash
   open -a Xcode
   ```

2. **Create New Project**
   - Click **"Create a new Xcode project"**
   - Or: **File → New → Project**

3. **Choose Template**
   - Select **iOS** tab
   - Choose **App**
   - Click **Next**

4. **Configure Project**
   - **Product Name**: `GreatFeelSwiftUI`
   - **Team**: Select your Apple Developer account (or personal team)
   - **Organization Identifier**: `com.greatfeel` (or your own)
   - **Bundle Identifier**: `com.greatfeel.GreatFeelSwiftUI`
   - **Interface**: **SwiftUI** ← IMPORTANT!
   - **Language**: **Swift** ← IMPORTANT!
   - **Storage**: None
   - **Include Tests**: Optional (uncheck for now)

5. **Save Location**
   - Navigate to and select the **GreatFeelSwiftUI** folder
   - Click **Create**
   - If asked to replace, click **Replace**

6. **Clean Up Default Files**
   - In Xcode's left sidebar, find these files:
     - `ContentView.swift` → **Delete** (Move to Trash)
     - `GreatFeelSwiftUIApp.swift` → **Delete** (Move to Trash)

---

### **Step 3: Add Source Files**

**THIS IS THE MOST CRITICAL STEP!**

1. **In Xcode's left sidebar**, find the **GreatFeelSwiftUI** folder (blue icon)

2. **Right-click** on it → **"Add Files to 'GreatFeelSwiftUI'..."**

3. **In the file picker:**
   - You should see: App, Models, ViewModels, Views, Services, Theme folders
   - Hold **⌘ (Command)** and click each folder to select:
     - ✅ **App**
     - ✅ **Models**
     - ✅ **ViewModels**
     - ✅ **Views**
     - ✅ **Services**
     - ✅ **Theme**

4. **At the bottom of the dialog, CHECK these:**
   - ✅ **"Copy items if needed"**
   - ✅ **"Create groups"** (NOT "Create folder references")
   - ✅ **"Add to targets: GreatFeelSwiftUI"** ← CRITICAL!

5. Click **"Add"**

---

### **Step 4: Verify Files Were Added**

In Xcode's Project Navigator (left sidebar), expand folders:

```
GreatFeelSwiftUI
├── GreatFeelSwiftUI
│   ├── App
│   │   └── GreatFeelSwiftUIApp.swift ✓
│   ├── Models
│   │   ├── User.swift ✓
│   │   ├── Goal.swift ✓
│   │   ├── Content.swift ✓
│   │   ├── Meditation.swift ✓
│   │   └── Mood.swift ✓
│   ├── ViewModels
│   │   ├── AuthViewModel.swift ✓
│   │   └── ... (5 files total) ✓
│   ├── Views
│   │   ├── Auth/ (3 files) ✓
│   │   ├── Main/ (5 files) ✓
│   │   ├── Components/ (5 files) ✓
│   │   └── Shared/ (2 files) ✓
│   ├── Services
│   │   ├── Network/ (2 files) ✓
│   │   ├── Storage/ (2 files) ✓
│   │   └── Audio/ (1 file) ✓
│   ├── Theme
│   │   ├── Colors.swift ✓
│   │   ├── Typography.swift ✓
│   │   └── Spacing.swift ✓
│   └── Info.plist ✓
└── Products
    └── GreatFeelSwiftUI.app
```

**Important checks:**
- ✅ No files should be **red** (red = missing)
- ✅ All files should be **black text** (normal)
- ✅ You should see **45+ Swift files** total

---

### **Step 5: Configure Info.plist** (if needed)

1. In Xcode, select **Info.plist** in the project navigator
2. Right-click → **Open As → Source Code**
3. Make sure it has these keys:

```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>

<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <false/>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
</dict>
```

If they're missing, copy from the `Info.plist` file in the GreatFeelSwiftUI folder.

---

### **Step 6: Configure Signing**

1. In Xcode, click on the **GreatFeelSwiftUI** project (blue icon at top)
2. Select the **GreatFeelSwiftUI** target
3. Go to **"Signing & Capabilities"** tab
4. Under **"Signing"**:
   - **Automatically manage signing**: ✅ Check this
   - **Team**: Select your team (personal team is fine)
   - Xcode will automatically fix signing issues

---

### **Step 7: Select Simulator**

At the top of Xcode window:
- Click the device selector (next to the Play button)
- Choose a simulator:
  - **iPhone 15 Pro** (recommended)
  - Or **iPhone 14 Pro**
  - Or any iPhone with iOS 16+

---

### **Step 8: Build and Run!**

1. **Clean Build Folder** (to be safe):
   - Press **⌘ Shift K**
   - Or: **Product → Clean Build Folder**

2. **Build and Run**:
   - Press **⌘ R**
   - Or: Click the **Play (▶️)** button at top left
   - Or: **Product → Run**

3. **Wait for Build**:
   - First build takes 30-60 seconds
   - You'll see progress in the top bar
   - Watch for any errors in the Issue Navigator (red icon)

4. **App Launches!**:
   - Simulator will open automatically
   - App will install and launch
   - You'll see the **Login Screen**! 🎉

---

## 🎮 Test the App

### **Login**
- **Email**: Any email (e.g., `test@example.com`)
- **Password**: Any password (e.g., `password`)
- Mock authentication is enabled - any credentials work!

### **Explore Features**
1. **Goals Tab**: See daily wellness goals
2. **Library Tab**: Browse content by category
3. **Relax Tab**: View meditation sessions
4. **Discover Tab**: See trending content
5. **Profile Tab**:
   - Change mood (watch background change!)
   - Toggle dark mode
   - Toggle audio on/off

---

## 🔧 Troubleshooting

### **Build Error: "File not found"**

This means files weren't added to the target correctly.

**Fix:**
1. Select any `.swift` file
2. Open **File Inspector** (right sidebar, first icon)
3. Find **"Target Membership"**
4. Make sure **GreatFeelSwiftUI** is ✅ checked
5. If not, check it for ALL files (or re-add files following Step 3)

---

### **Build Error: "No such module"**

**Fix:**
1. Clean: **⌘ Shift K**
2. Delete Derived Data:
   - **Xcode → Settings → Locations**
   - Click arrow next to **Derived Data**
   - Delete the **GreatFeelSwiftUI** folder
3. Restart Xcode
4. Build again: **⌘ R**

---

### **Signing Error**

**Fix:**
1. Go to **Signing & Capabilities** tab
2. Click **"+ Capability"** if needed
3. Make sure your team is selected
4. If still issues, click **"Download Manual Profiles"** in Xcode settings

---

### **Simulator Won't Launch**

**Fix:**
1. Close simulator
2. **Xcode → Window → Devices and Simulators**
3. Select your simulator
4. Click the **Play** button to boot it
5. Try running again

---

### **"Nuclear Option" - Start Fresh**

If nothing works:

```bash
# Close Xcode first!
cd GreatFeelSwiftUI
rm -rf GreatFeelSwiftUI.xcodeproj
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*
```

Then repeat from Step 2 above.

---

## 📱 Run on Real Device

### **Requirements**
- iPhone or iPad with iOS 16+
- USB cable
- Free Apple Developer account (built-in to Xcode)

### **Steps**
1. Connect your device via USB
2. Trust the computer on your device
3. In Xcode, select your device from the device menu
4. Go to **Signing & Capabilities**
5. Select your team
6. Change Bundle ID if needed (must be unique)
7. Press **⌘ R** to build and run
8. On device: **Settings → General → VPN & Device Management**
9. Trust your developer certificate
10. Launch app from home screen!

---

## ✅ Success Checklist

After following this guide:
- [ ] Xcode project created
- [ ] All source folders added (45+ files)
- [ ] No red files in project navigator
- [ ] Info.plist configured
- [ ] Signing configured (team selected)
- [ ] Clean build succeeds
- [ ] App runs in simulator
- [ ] Login screen appears
- [ ] Can login with any credentials
- [ ] All 5 tabs work
- [ ] Can change mood and see background change
- [ ] Can toggle dark mode

---

## 🎉 You're Done!

Your SwiftUI app is now running!

**What's Next?**
- Customize the design
- Connect to your backend API (update URLs in `APIClient.swift`)
- Add your own content
- Test on real devices
- Submit to TestFlight
- Launch on App Store!

---

## 📞 Need More Help?

**Documentation:**
- `FIX_BUILD_ERROR.md` - Detailed build error solutions
- `QUICKSTART.md` - Quick setup guide
- `README.md` - Project overview
- `MIGRATION_SUMMARY.md` - Migration details

**Common Resources:**
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Xcode Documentation](https://developer.apple.com/xcode/)

---

Enjoy your native SwiftUI app! 🚀
