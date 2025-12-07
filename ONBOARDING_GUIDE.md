# User Onboarding System - Implementation Guide

## Overview

The GreatFeel app now features a comprehensive 5-question onboarding flow that collects user preferences and personalizes their experience. The system stores responses locally and provides personalized content recommendations.

## ✨ Features

### 1. **Enhanced Onboarding Questions**
- ✅ **Question 1**: Emotional state assessment (3 options)
- ✅ **Question 2**: Primary wellness goal (4 options)
- ✅ **Question 3**: Daily time commitment (4 options)
- ✅ **Question 4**: Experience level with mindfulness (4 options)
- ✅ **Question 5**: Preferred activities - **multiple selection** (6 options)

### 2. **Data Persistence**
All user responses are stored in `UserDefaults` using the `UserOnboardingData` model.

### 3. **Personalization Service**
Uses onboarding data to provide:
- Personalized welcome messages
- Recommended content categories
- Optimal session durations
- Content difficulty levels
- Daily wellness tips

## 📁 New Files Added

```
Models/
├── UserOnboardingData.swift          # Data model for user responses

Services/
├── PersonalizationService.swift      # Personalization logic

Views/Components/
├── PersonalizedWelcomeBanner.swift   # Example usage component
```

## 🔧 Updated Files

```
Models/
├── OnboardingQuestion.swift          # Added 2 new questions + multiple selection support

Views/Onboarding/
├── OnboardingView.swift              # Enhanced with data persistence & multi-select
```

## 💾 Data Model Structure

### UserOnboardingData
```swift
struct UserOnboardingData {
    var emotionalState: EmotionalState?         // Q1
    var primaryGoal: PrimaryGoal?               // Q2
    var timeCommitment: TimeCommitment?         // Q3
    var experienceLevel: ExperienceLevel?       // Q4
    var preferredActivities: [ActivityType]     // Q5 (multiple)
    var completedAt: Date
}
```

### Enums with Built-in Intelligence

Each enum includes helpful properties:

**EmotionalState**
- `personalizedMessage`: Custom welcome message
- `recommendedCategories`: Content categories to prioritize

**PrimaryGoal**
- `icon`: SF Symbol icon name
- `recommendedContent`: Content types to show

**TimeCommitment**
- `recommendedSessionLength`: Minutes per session

**ExperienceLevel**
- `icon`: SF Symbol for skill level
- `recommendedDifficulty`: Beginner/Intermediate/Advanced

**ActivityType**
- `icon`: SF Symbol for activity type

## 🚀 Usage Examples

### 1. Access Personalization Service

```swift
import SwiftUI

struct HomeView: View {
    private let personalization = PersonalizationService.shared

    var body: some View {
        VStack {
            // Show personalized welcome message
            Text(personalization.getWelcomeMessage())
                .font(.headline)

            // Show daily tip
            Text(personalization.getDailyTip())
                .font(.subheadline)
        }
    }
}
```

### 2. Get Recommended Content

```swift
// Get recommended categories based on user's goals and emotional state
let categories = PersonalizationService.shared.getRecommendedCategories()
// Returns: ["mindfulness", "stress", "anxiety", "meditation", ...]

// Get recommended content types based on preferred activities
let contentTypes = PersonalizationService.shared.getRecommendedContentTypes()
// Returns: ["meditation", "audio", "breathing", ...]

// Get optimal session duration
let duration = PersonalizationService.shared.getRecommendedSessionDuration()
// Returns: 7, 15, 25, or custom based on user's time commitment
```

### 3. Filter Content

```swift
struct ContentLibraryView: View {
    @State private var recommendedCategories: [String] = []

    var body: some View {
        List {
            ForEach(recommendedCategories, id: \.self) { category in
                CategoryRow(category: category)
            }
        }
        .onAppear {
            recommendedCategories = PersonalizationService.shared.getRecommendedCategories()
        }
    }
}
```

### 4. Check Onboarding Status

```swift
if PersonalizationService.shared.hasCompletedOnboarding() {
    // Show personalized content
} else {
    // Show onboarding flow
}
```

### 5. Access Raw Onboarding Data

```swift
if let data = UserDefaultsService.shared.onboardingData {
    print("User's emotional state: \(data.emotionalState?.rawValue ?? "N/A")")
    print("Primary goal: \(data.primaryGoal?.rawValue ?? "N/A")")
    print("Preferred activities: \(data.preferredActivities.map { $0.rawValue })")
}
```

### 6. Get Full Summary

```swift
if let summary = PersonalizationService.shared.getOnboardingSummary() {
    print(summary.description)
    /*
    📊 Your Personalized Profile:

    🎯 Goal: Reduce stress and anxiety
    ⏱️ Session Duration: 15 minutes
    📈 Difficulty: beginner

    🎨 Interests:
       • Guided meditation
       • Breathing exercises
       • Relaxing sounds & music

    📚 Recommended Categories:
       • Mindfulness
       • Stress
       • Anxiety
    */
}
```

## 🎨 UI Features

### Single Selection Questions (Q1-Q4)
- User taps to select one option
- Selected option shows purple border & color
- Character bounces on selection
- "Next" button enabled when selection made

### Multiple Selection Question (Q5)
- User can tap multiple options
- All selected options show purple border
- "Select all that apply" hint displayed
- Character bounces on each selection
- Must select at least one to proceed

### Progress Indicator
- Visual progress bar at top
- Updates as user progresses through questions

### Completion Animation
- Rotating character
- Expanding circles
- "All set!" message
- "Begin Journey" button

## 🔄 Data Flow

1. **User completes onboarding** → Answers stored in local state
2. **On final question completion** → `saveOnboardingData()` called
3. **Data converted to enums** → Stored in `UserOnboardingData`
4. **Saved to UserDefaults** → Persists across app launches
5. **PersonalizationService reads data** → Provides recommendations
6. **App uses recommendations** → Customizes user experience

## 🧪 Testing

### Reset Onboarding (for testing)
```swift
PersonalizationService.shared.resetOnboarding()
// Clears all onboarding data and flags
// User will see onboarding flow again
```

### Debug Output
When onboarding completes, console logs:
```
✅ Onboarding data saved successfully:
   Emotional State: Going through something difficult recently
   Primary Goal: Reduce stress and anxiety
   Time Commitment: 10-20 minutes
   Experience Level: New to mindfulness & meditation
   Preferred Activities: ["Guided meditation", "Breathing exercises"]
```

## 🎯 Personalization Logic

### Emotional State → Content Categories
- **Difficult recently** → stress, anxiety, sleep, mindfulness
- **Ongoing challenges** → mindfulness, anxiety, stress, meditation
- **Doing okay** → mindfulness, sleep, productivity, meditation

### Primary Goal → Content Types
- **Reduce stress** → breathing exercises, stress management, relaxation
- **Improve sleep** → sleep meditation, bedtime routine, sleep hygiene
- **Build mindfulness** → meditation basics, mindful living, daily practices
- **Just exploring** → introduction to wellness, beginner's guide, mixed content

### Time Commitment → Session Length
- **5-10 minutes** → 7 min sessions
- **10-20 minutes** → 15 min sessions
- **20-30 minutes** → 25 min sessions
- **Flexible** → 15 min sessions (default)

### Experience Level → Difficulty
- **New** → beginner
- **Some practice** → beginner-intermediate
- **Regular** → intermediate
- **Experienced** → advanced

## 📱 Integration Points

You can integrate personalization in:

1. **Home Screen** - Show personalized welcome & daily tips
2. **Content Library** - Filter by recommended categories
3. **Meditation Sessions** - Suggest appropriate duration
4. **Search/Discovery** - Prioritize recommended content types
5. **Notifications** - Send reminders based on time commitment
6. **Progress Tracking** - Set goals based on experience level

## 🎨 Sample Component

See `PersonalizedWelcomeBanner.swift` for a complete working example that demonstrates:
- Displaying personalized messages
- Showing daily tips
- Recommended session durations
- Category chips
- Profile summary

## 🔐 Privacy

All onboarding data is stored **locally** on the device using `UserDefaults`. No data is sent to servers. Users can reset their preferences at any time.

## 📝 Future Enhancements

Consider adding:
- [ ] Ability to edit onboarding responses later
- [ ] More granular activity preferences
- [ ] A/B testing different question variations
- [ ] Analytics to track which paths lead to better engagement
- [ ] Machine learning to refine recommendations over time
- [ ] Export/import preferences for multiple devices

---

## 🎉 Summary

The onboarding system now:
1. ✅ Collects comprehensive user preferences (5 questions)
2. ✅ Supports both single and multiple selection
3. ✅ Persists data across app launches
4. ✅ Provides intelligent personalization
5. ✅ Offers easy-to-use API for the entire app
6. ✅ Includes sample components for quick integration

Use `PersonalizationService.shared` throughout your app to create a truly personalized wellness experience! 🌟
