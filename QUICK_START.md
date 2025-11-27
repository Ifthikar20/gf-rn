# 🚀 Quick Start Guide - GreatFeel SwiftUI

**GreatFeel** is a native iOS wellness app built entirely in SwiftUI. Zero dependencies. Pure Swift.

---

## 📱 Build & Run on macOS

### Prerequisites
- **macOS** (Ventura 13.0+)
- **Xcode** 15.0+ (from App Store)
- **iOS Simulator** (included with Xcode)

---

## 🎯 Three Ways to Run

### **Option 1: Quick Launch (Recommended)**

```bash
cd /path/to/gf-rn/GreatFeelSwiftUI
open GreatFeelSwiftUI.xcodeproj
```

Then in Xcode:
1. Select a simulator (iPhone 15 Pro recommended)
2. Press **⌘R** or click the **Play** button
3. Wait for build to complete (~30-60 seconds first time)
4. App launches in simulator! 🎉

---

### **Option 2: Complete Setup Script**

```bash
cd /path/to/gf-rn/GreatFeelSwiftUI
./setup_and_build.sh
```

This script will:
- Validate project structure
- Generate/check Xcode project
- Attempt build to find errors
- Open in Xcode

---

### **Option 3: Rebuild Xcode Project**

If you need to regenerate the Xcode project from scratch:

```bash
cd /path/to/gf-rn/GreatFeelSwiftUI
./rebuild_project.sh
```

This will:
- Delete existing Xcode project
- Regenerate from Python script
- Open in Xcode

---

## 🗂️ Project Structure

```
gf-rn/
├── GreatFeelSwiftUI/
│   ├── GreatFeelSwiftUI.xcodeproj    # Xcode project (ready to use!)
│   ├── GreatFeelSwiftUI/              # Source code
│   │   ├── App/                       # App entry point
│   │   │   └── GreatFeelSwiftUIApp.swift
│   │   ├── Models/                    # Data models (5 files)
│   │   │   ├── User.swift
│   │   │   ├── Goal.swift
│   │   │   ├── Content.swift
│   │   │   ├── Meditation.swift
│   │   │   └── Mood.swift
│   │   ├── ViewModels/                # State management (5 files)
│   │   ├── Views/                     # UI screens (15+ files)
│   │   │   ├── Auth/
│   │   │   ├── Main/
│   │   │   ├── Components/
│   │   │   └── Shared/
│   │   ├── Services/                  # Networking, storage, audio
│   │   └── Theme/                     # Colors, typography, spacing
│   ├── Info.plist                     # App configuration
│   ├── rebuild_project.sh             # Regenerate project script
│   ├── setup_and_build.sh             # Complete setup script
│   └── Documentation files
├── BUILD_AND_RUN.md                   # Detailed guide
├── QUICK_START.md                     # This file
└── README.md                          # Project overview
```

---

## 🎮 Using the App

### **Login**
- Email: Any email (e.g., `test@example.com`)
- Password: Any password (mock auth enabled)
- Just tap "Sign In" to enter

### **Features**
1. **Goals Tab** - Daily wellness tasks (morning/day/evening)
2. **Library Tab** - Browse content by category
3. **Relax Tab** - Meditation sessions
4. **Discover Tab** - Trending content
5. **Profile Tab** - Settings, mood selector, dark mode

---

## 🔧 Troubleshooting

### **Build Error: "No such file or directory"**

Files not added to target correctly.

**Fix:**
1. Open Xcode project
2. Select any `.swift` file
3. Open File Inspector (right sidebar)
4. Check **Target Membership** → Ensure "GreatFeelSwiftUI" is checked

Or regenerate:
```bash
cd GreatFeelSwiftUI
./rebuild_project.sh
```

---

### **Signing Error**

1. In Xcode: Click project name (top left)
2. Select **GreatFeelSwiftUI** target
3. Go to **Signing & Capabilities**
4. Enable **Automatically manage signing**
5. Select your **Team** (personal team is fine)

---

### **Simulator Won't Launch**

1. Open **Xcode** → **Window** → **Devices and Simulators**
2. Select an iOS simulator
3. Click **Boot** button
4. Try running again

---

### **Clean Build (Nuclear Option)**

In Xcode:
- Press: **⌘ + Shift + K** (Clean Build Folder)

Or from command line:
```bash
cd /path/to/gf-rn/GreatFeelSwiftUI
rm -rf ~/Library/Developer/Xcode/DerivedData/GreatFeelSwiftUI-*
./rebuild_project.sh
```

---

## 📋 Verification Checklist

After running the app, verify:
- [ ] App launches in simulator
- [ ] Login screen appears
- [ ] Can log in with any credentials
- [ ] All 5 tabs are visible and work
- [ ] Can change mood (background changes)
- [ ] Can toggle dark mode
- [ ] Navigation works between screens

---

## 🎉 Success!

Your SwiftUI app is now running with:
- ✅ Zero external dependencies
- ✅ 100% Swift code
- ✅ Native iOS performance
- ✅ Clean, maintainable codebase
- ✅ 45+ Swift files in MVVM architecture

---

## 📚 Additional Documentation

- **BUILD_AND_RUN.md** - Detailed build guide with manual steps
- **COMPILATION_FIXES.md** - Swift compilation fixes documentation
- **GreatFeelSwiftUI/README.md** - SwiftUI project details
- **GreatFeelSwiftUI/FIX_BUILD_ERROR.md** - Common error solutions

---

## 🚀 Next Steps

1. **Test Features** - Explore all 5 tabs
2. **Customize** - Update colors in `Theme/Colors.swift`
3. **Backend** - Connect to your API in `Services/Network/APIClient.swift`
4. **Real Device** - Test on physical iPhone
5. **TestFlight** - Prepare for distribution
6. **App Store** - Submit for review

---

## 💡 Quick Tips

- **Hot Reload**: Press **⌘R** in Xcode to rebuild
- **Console Logs**: **View** → **Debug Area** → **Show Debug Area** (⌘⇧Y)
- **Inspect UI**: Click **View Hierarchy** button when running
- **Breakpoints**: Click line numbers to add breakpoints

---

## 📞 Need Help?

Check the documentation or visit:
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [Xcode Documentation](https://developer.apple.com/xcode/)

---

**Enjoy your native SwiftUI app!** 🎉
