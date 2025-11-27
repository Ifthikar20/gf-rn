# GreatFeel SwiftUI - Setup Guide

## 📋 Quick Start

Follow these steps to set up the Xcode project and run the app.

### Step 1: Create Xcode Project

1. Open Xcode
2. Click "Create a new Xcode project"
3. Select **iOS** → **App**
4. Configure your project:
   - **Product Name**: `GreatFeelSwiftUI`
   - **Team**: Select your team
   - **Organization Identifier**: `com.greatfeel` (or your own)
   - **Bundle Identifier**: `com.greatfeel.GreatFeelSwiftUI`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Storage**: None
   - **Include Tests**: Optional
5. Save in the `GreatFeelSwiftUI` folder (replace the existing folder if asked)

### Step 2: Add Source Files

1. In Xcode, **delete** the default files:
   - `ContentView.swift`
   - `GreatFeelSwiftUIApp.swift` (we have our own)

2. **Drag and drop** these folders into the Xcode project navigator:
   - `App/`
   - `Models/`
   - `ViewModels/`
   - `Views/`
   - `Services/`
   - `Theme/`

3. When prompted, select:
   - ✅ **Copy items if needed**
   - ✅ **Create groups**
   - ✅ **Add to targets: GreatFeelSwiftUI**

### Step 3: Configure Info.plist

1. In Xcode, select your project in the navigator
2. Select the target "GreatFeelSwiftUI"
3. Go to the **Info** tab
4. Add these keys:

#### Required Keys

**Background Modes:**
- Click the **+** button next to "Custom iOS Target Properties"
- Add: `UIBackgroundModes` (Array)
- Add item: `audio` (String)

**App Transport Security:**
- Add: `NSAppTransportSecurity` (Dictionary)
  - Add: `NSAllowsArbitraryLoads` (Boolean) = NO
  - Add: `NSExceptionDomains` (Dictionary)
    - Add: `localhost` (Dictionary)
      - Add: `NSExceptionAllowsInsecureHTTPLoads` (Boolean) = YES

Or simply replace the default Info.plist content with the provided `Info.plist` file.

### Step 4: Set Deployment Target

1. Select your project → Target → General
2. Set **Minimum Deployments** to **iOS 16.0**

### Step 5: Build and Run

1. Select a simulator (iPhone 15 Pro recommended) or your device
2. Press **Cmd+R** or click the **Play** button
3. Wait for the build to complete
4. The app should launch with the login screen! 🎉

## 🔧 Troubleshooting

### Build Errors

**"Cannot find type 'X' in scope"**
- Make sure all folders are properly added to the target
- Check that files are in the correct groups
- Clean build folder: **Cmd+Shift+K**

**"No such module 'X'"**
- This project has no external dependencies
- Make sure you're using the correct SDK (iOS 16.0+)

**Keychain errors**
- These are normal in simulator
- Keychain works perfectly on real devices

### Runtime Errors

**"Failed to setup audio session"**
- This is normal in simulator
- Audio works perfectly on real devices

**Images not loading**
- Check internet connection
- AsyncImage requires network access
- Images are loaded from Unsplash CDN

## 🎯 First Run

### Login Credentials (Mock)
```
Email: any@email.com
Password: any password
```

The app uses mock authentication in development mode. Any email/password combination will work!

### Testing Features

1. **Login**: Enter any credentials and sign in
2. **Goals**: Browse daily goals organized by time
3. **Profile**: Change mood and see background change
4. **Dark Mode**: Toggle dark mode in profile
5. **Audio**: Enable/disable background audio

## 📱 Running on Device

### Requirements
- Apple Developer account (free tier works)
- iOS device with iOS 16.0+

### Steps
1. Connect your iPhone/iPad
2. In Xcode: Select your device from the device menu
3. Select your project → Signing & Capabilities
4. Select your team
5. Fix any signing issues
6. Press **Cmd+R** to build and run

## 🚀 Production Setup

### Backend Integration

1. **Update API Base URL** in `Services/Network/APIClient.swift`:
```swift
#if DEBUG
self.baseURL = "https://your-dev-api.com/api"
#else
self.baseURL = "https://your-prod-api.com/api"
#endif
```

2. **Enable Real Authentication** in `Services/Network/AuthAPI.swift`:
```swift
// Comment out mock response
// Uncomment real API call:
return try await client.request(
    endpoint: "/auth/login",
    method: .post,
    body: credentials,
    requiresAuth: false
)
```

### App Store Preparation

1. **Update Bundle Identifier**
   - Project → Target → General → Bundle Identifier

2. **Update App Name**
   - Project → Target → Info → Bundle Display Name

3. **Add App Icons**
   - Assets.xcassets → AppIcon
   - Add icons for all sizes

4. **Update Version Numbers**
   - Project → Target → General → Version/Build

5. **Configure Signing**
   - Project → Target → Signing & Capabilities
   - Select your distribution certificate

## 📦 Project Structure

```
GreatFeelSwiftUI/
├── GreatFeelSwiftUI.xcodeproj/     # Xcode project (you create this)
├── GreatFeelSwiftUI/               # Source files
│   ├── App/                        # ✅ Already created
│   ├── Models/                     # ✅ Already created
│   ├── ViewModels/                 # ✅ Already created
│   ├── Views/                      # ✅ Already created
│   ├── Services/                   # ✅ Already created
│   └── Theme/                      # ✅ Already created
├── Info.plist                      # ✅ Already created
├── README.md                       # ✅ Already created
└── SETUP.md                        # ✅ This file
```

## ✅ Verification Checklist

After setup, verify:

- [ ] Xcode project created successfully
- [ ] All source folders added to target
- [ ] Info.plist configured
- [ ] Minimum deployment target set to iOS 16.0
- [ ] Project builds without errors
- [ ] App runs in simulator
- [ ] Login screen appears
- [ ] Can login with any credentials
- [ ] All 5 tabs visible after login
- [ ] Goals screen shows goals
- [ ] Profile screen loads
- [ ] Mood selector works
- [ ] Dark mode toggle works

## 🎓 Learning Resources

### SwiftUI
- [Apple SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)

### Architecture
- MVVM pattern
- Combine framework
- Observable objects

## 🆘 Need Help?

Common issues and solutions:

1. **Build fails**: Clean build folder (Cmd+Shift+K) and rebuild
2. **Images not loading**: Check internet connection
3. **Audio not working**: Normal in simulator, test on device
4. **Dark mode issues**: Check system settings in simulator

## 🎉 Success!

If you see the login screen and can navigate to the main tabs, congratulations! Your SwiftUI migration is complete and running.

**Next Steps:**
1. Customize the design to your liking
2. Connect to your backend API
3. Add more features
4. Test thoroughly
5. Deploy to TestFlight
6. Submit to App Store

Welcome to native iOS development! 🚀
