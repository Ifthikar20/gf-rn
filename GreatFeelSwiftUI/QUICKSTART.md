# GreatFeel SwiftUI - Quick Start Guide

## 🚀 Super Simple Setup (3 Steps)

### Step 1: Run the Setup Script
```bash
cd GreatFeelSwiftUI
./create_xcode_project.sh
```

This will:
- ✅ Create the Xcode project automatically
- ✅ Open Xcode for you
- ✅ Set up all the configurations

### Step 2: Add Source Files in Xcode

When Xcode opens:

1. In the left sidebar (Project Navigator), **right-click** on the **GreatFeelSwiftUI** folder (the blue icon)
2. Select **"Add Files to 'GreatFeelSwiftUI'..."**
3. In the file picker:
   - Select ALL the folders: `App`, `Models`, `ViewModels`, `Views`, `Services`, `Theme`
   - ✅ Check **"Copy items if needed"**
   - ✅ Check **"Create groups"**
   - ✅ Make sure **"Add to targets: GreatFeelSwiftUI"** is checked
4. Click **"Add"**

### Step 3: Build and Run

1. At the top of Xcode, select a simulator (e.g., **iPhone 15 Pro**)
2. Press **⌘R** (or click the Play button)
3. Wait for the build to complete
4. **The app will launch!** 🎉

---

## 🎯 Login Credentials

The app uses **mock authentication** for development.

**Any email and password will work!**

For example:
- Email: `test@example.com`
- Password: `password`

---

## ✅ What to Expect

After logging in, you'll see:

- **Goals Tab**: Daily wellness goals (Morning/Day/Evening)
- **Library Tab**: Content filtered by category
- **Relax Tab**: Meditation sessions
- **Discover Tab**: Trending content
- **Profile Tab**: Settings, mood selector, dark mode

---

## 🎨 Try These Features

1. **Change Mood**: Go to Profile → Select different moods → Watch background change
2. **Dark Mode**: Go to Profile → Toggle Dark Mode switch
3. **Audio**: Go to Profile → Toggle Background Audio on/off
4. **Goals**: Tap checkboxes to mark goals as complete
5. **Navigation**: Browse all 5 tabs

---

## 🔧 Troubleshooting

### "No signing certificate"
1. In Xcode, select the project in the navigator
2. Select the target "GreatFeelSwiftUI"
3. Go to "Signing & Capabilities" tab
4. Select your team from the "Team" dropdown
5. Xcode will automatically create a signing certificate

### "Cannot find 'X' in scope"
- Make sure you added all the source folders in Step 2
- Check that files are added to the target (they should have a checkmark)
- Clean build folder: **⌘Shift+K** and rebuild

### Build errors
1. Clean build folder: **⌘Shift+K**
2. Delete derived data: Xcode → Settings → Locations → Derived Data → Delete
3. Rebuild: **⌘R**

---

## 📖 Full Documentation

For more details, see:
- **README.md** - Complete project documentation
- **SETUP.md** - Detailed setup instructions
- **MIGRATION_SUMMARY.md** - Migration details

---

## 🆘 Need Help?

Common issues:

**Q: Script says "Xcode is not installed"**
A: Install Xcode from the Mac App Store

**Q: Can't find the source folders**
A: Make sure you're in the GreatFeelSwiftUI directory when you add files

**Q: App crashes on launch**
A: This is a SwiftUI preview issue - run on a real device or restart Xcode

---

## 🎉 That's It!

You now have a **fully native SwiftUI app** with:
- ✅ Zero React Native dependencies
- ✅ 100% native iOS code
- ✅ All features working
- ✅ Beautiful UI
- ✅ Dark mode support
- ✅ Background audio
- ✅ Secure authentication

Enjoy your new SwiftUI app! 🚀
