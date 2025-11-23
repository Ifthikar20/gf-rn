# GF Wellness - React Native App

A comprehensive React Native wellness application with authentication, goal tracking, and media library features. This is a React Native port of the GF iOS Swift application.

## Features

- **Authentication Flow**
  - Email/password login and registration
  - Biometric authentication (Face ID / Touch ID)
  - Password reset functionality
  - Secure token management

- **Goal Management**
  - Create, read, update, delete goals
  - Track progress with visual indicators
  - Multiple goal categories (Meditation, Audio, Video, etc.)
  - Offline support with sync when online

- **Media Library**
  - Meditation sessions
  - Audio tracks
  - Video content
  - Organized by categories

- **User Profile**
  - View and edit profile information
  - App settings
  - Sign out functionality

## Tech Stack

- **React Native** 0.73.x
- **TypeScript** for type safety
- **React Navigation** for navigation
- **Context API** for state management
- **AsyncStorage** for local data persistence
- **React Native Biometrics** for Face ID/Touch ID
- **NetInfo** for network status monitoring

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** >= 18.x
- **npm** or **yarn**
- **React Native CLI**
- **Xcode** (for iOS development) - macOS only
- **Android Studio** (for Android development)
- **CocoaPods** (for iOS)

## Installation

### 1. Clone the repository

```bash
git clone <repository-url>
cd gf-rn
```

### 2. Install dependencies

```bash
npm install
# or
yarn install
```

### 3. iOS Setup (macOS only)

```bash
# Install CocoaPods dependencies
cd ios && pod install && cd ..
```

### 4. Configure vector icons

For iOS, add the following to your `ios/GFWellness/Info.plist`:

```xml
<key>UIAppFonts</key>
<array>
  <string>FontAwesome.ttf</string>
</array>
```

For Android, edit `android/app/build.gradle`:

```gradle
apply from: "../../node_modules/react-native-vector-icons/fonts.gradle"
```

## Running the App

### iOS (macOS only)

```bash
# Start Metro bundler
npm start

# In another terminal, run iOS
npm run ios

# Or specify a simulator
npx react-native run-ios --simulator="iPhone 15 Pro"
```

### Android

```bash
# Start Metro bundler
npm start

# In another terminal, run Android
npm run android
```

### Development Commands

```bash
# Start Metro bundler with cache reset
npm run reset-cache

# Type check
npm run type-check

# Lint
npm run lint

# Run tests
npm test
```

## Project Structure

```
src/
├── App.tsx                 # Main app entry point
├── config/
│   └── Config.ts           # App configuration & API endpoints
├── context/
│   ├── AuthContext.tsx     # Authentication state management
│   └── GoalContext.tsx     # Goals state management
├── models/
│   ├── User.ts             # User model
│   └── Goal.ts             # Goal model & categories
├── navigation/
│   ├── RootNavigator.tsx   # Root navigation (Auth/Main)
│   ├── AuthNavigator.tsx   # Auth stack navigator
│   ├── MainTabNavigator.tsx# Main tab navigator
│   └── GoalsNavigator.tsx  # Goals stack navigator
├── screens/
│   ├── auth/
│   │   ├── LoginScreen.tsx
│   │   ├── RegisterScreen.tsx
│   │   └── ForgotPasswordScreen.tsx
│   ├── goals/
│   │   ├── GoalsListScreen.tsx
│   │   ├── GoalDetailScreen.tsx
│   │   └── CreateGoalScreen.tsx
│   └── main/
│       ├── HomeScreen.tsx
│       ├── LibraryScreen.tsx
│       └── ProfileScreen.tsx
├── services/
│   ├── AuthService.ts      # Authentication API
│   ├── GoalService.ts      # Goals API with caching
│   ├── NetworkService.ts   # HTTP client
│   ├── StorageService.ts   # Secure storage
│   └── BiometricService.ts # Biometric auth
├── components/
│   └── goals/
│       ├── GoalRowView.tsx
│       └── GoalProgressCard.tsx
└── theme/
    └── colors.ts           # App color palette
```

## Configuration

### API Configuration

Edit `src/config/Config.ts` to set your API endpoints:

```typescript
// Development
apiBaseURL: 'https://dev-api.yourserver.com/v1'

// Production
apiBaseURL: 'https://api.yourserver.com/v1'
```

### Environment Variables

For production builds, use environment-specific configuration:

1. Install `react-native-config`:
   ```bash
   npm install react-native-config
   ```

2. Create `.env` files for each environment:
   ```
   API_BASE_URL=https://api.yourserver.com/v1
   CDN_BASE_URL=https://cdn.yourserver.com
   ```

## Authentication Flow

The app uses JWT tokens for authentication:

1. **Login/Register**: Sends credentials to API, receives access & refresh tokens
2. **Token Storage**: Tokens are stored securely using AsyncStorage
3. **Auto Refresh**: Access tokens are automatically refreshed before expiry
4. **Biometric**: Optional Face ID/Touch ID for quick login (when tokens exist)

## Offline Support

The app supports offline mode:

1. Goals are cached locally using AsyncStorage
2. Changes made offline are queued as "pending changes"
3. When online, pending changes sync automatically
4. Network status is monitored using NetInfo

## Troubleshooting

### Metro bundler issues

```bash
# Clear Metro cache
npm run reset-cache

# Or manually
npx react-native start --reset-cache
```

### iOS build issues

```bash
# Clean iOS build
cd ios && xcodebuild clean && cd ..

# Reinstall pods
cd ios && pod deintegrate && pod install && cd ..
```

### Android build issues

```bash
# Clean Android build
cd android && ./gradlew clean && cd ..
```

### Biometrics not working

1. Ensure device has Face ID/Touch ID configured
2. Check app permissions in device settings
3. Verify `react-native-biometrics` is properly linked

## Building for Production

### iOS

```bash
# Create release build
npx react-native run-ios --configuration Release
```

Or open `ios/GFWellness.xcworkspace` in Xcode and archive.

### Android

```bash
# Generate release APK
cd android && ./gradlew assembleRelease

# Generate release AAB (for Play Store)
cd android && ./gradlew bundleRelease
```

## API Endpoints

The app expects the following API endpoints:

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /auth/login | User login |
| POST | /auth/register | User registration |
| POST | /auth/refresh | Refresh access token |
| POST | /auth/logout | User logout |
| POST | /auth/forgot-password | Request password reset |
| GET | /user/profile | Get user profile |
| GET | /goals | List all goals |
| POST | /goals | Create new goal |
| PUT | /goals/:id | Update goal |
| DELETE | /goals/:id | Delete goal |
| PATCH | /goals/:id/progress | Update goal progress |

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.
