# API Endpoints Documentation

This document outlines all the API endpoints that will be implemented to match the web application's backend.

## Base Configuration

```swift
// Base URL (to be configured)
let baseURL = "https://api.greatfeel.com" // or your backend URL

// All requests should include:
// - Content-Type: application/json
// - Authorization: Bearer {access_token} (for authenticated requests)
// - withCredentials: true (sends httpOnly cookies)
```

---

## 1. Authentication Endpoints

### POST /auth/login
**Purpose:** User login
**Auth Required:** No
**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "avatar": "https://...",
    "createdAt": "2025-11-29T12:00:00Z",
    "updatedAt": "2025-11-29T12:00:00Z"
  },
  "tokens": {
    "accessToken": "eyJhbGc...",
    "refreshToken": "eyJhbGc...",
    "expiresIn": 3600
  }
}
```

**Current Implementation:** Hardcoded (admin/admin)
**Swift Implementation:** `AuthAPI.login(credentials:)`

---

### POST /auth/register
**Purpose:** User registration
**Auth Required:** No
**Request Body:**
```json
{
  "name": "John Doe",
  "email": "user@example.com",
  "password": "password123",
  "confirmPassword": "password123"
}
```

**Response:** Same as login
**Current Implementation:** Hardcoded mock
**Swift Implementation:** `AuthAPI.register(credentials:)`

---

### POST /auth/logout
**Purpose:** User logout
**Auth Required:** Yes
**Request Body:** None
**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

**Swift Implementation:** `AuthAPI.logout()`

---

### GET /auth/me
**Purpose:** Get current authenticated user
**Auth Required:** Yes
**Response:**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe",
  "avatar": "https://...",
  "createdAt": "2025-11-29T12:00:00Z",
  "updatedAt": "2025-11-29T12:00:00Z"
}
```

**Swift Implementation:** `AuthAPI.getCurrentUser()`

---

### POST /auth/refresh
**Purpose:** Refresh access token
**Auth Required:** Yes (refresh token required)
**Response:** New access token in cookies
**Swift Implementation:** To be implemented

---

### POST /auth/forgot-password
**Purpose:** Request password reset
**Auth Required:** No
**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset email sent"
}
```

**Swift Implementation:** `AuthAPI.forgotPassword(email:)`

---

### POST /auth/reset-password
**Purpose:** Reset password with token
**Auth Required:** No
**Request Body:**
```json
{
  "token": "reset_token",
  "password": "newpassword123",
  "confirmPassword": "newpassword123"
}
```

**Swift Implementation:** `AuthAPI.resetPassword(request:)`

---

### GET /auth/google
**Purpose:** Google OAuth login
**Auth Required:** No
**Flow:** Redirect-based OAuth
**Swift Implementation:** To be implemented

---

## 2. Content & Streaming Endpoints

### GET /api/streaming/{contentId}
**Purpose:** Get HLS streaming URL for video content
**Auth Required:** Yes
**Query Parameters:**
- `quality` (optional): "720p", "1080p"

**Response:**
```json
{
  "hls_url": "https://cloudfront.net/video.m3u8",
  "qualities": ["720p", "1080p"],
  "content_id": "uuid",
  "expert_name": "Dr. Smith",
  "category": "Meditation",
  "duration": 300,
  "title": "Morning Meditation",
  "description": "..."
}
```

**Swift Implementation:** To be implemented

---

### GET /api/streaming/content/{contentId}/stream
**Purpose:** Get audio HLS streaming URL
**Auth Required:** Yes
**Query Parameters:**
- `quality` (optional)

**Response:**
```json
{
  "hls_url": "https://cloudfront.net/audio.m3u8",
  "content_id": "uuid",
  "expert_name": "Dr. Smith",
  "category": "Sleep",
  "duration": 1800,
  "title": "Sleep Story",
  "description": "...",
  "thumbnail_url": "https://..."
}
```

**Swift Implementation:** To be implemented

---

### GET /api/browse
**Purpose:** Browse all content (videos + audio)
**Auth Required:** Yes
**Query Parameters:**
- `page` (default: 1)
- `page_size` (default: 20)
- `category` (optional): "meditation", "sleep", etc.
- `expert` (optional): Expert name filter

**Response:**
```json
{
  "content": [
    {
      "id": "uuid",
      "title": "...",
      "description": "...",
      "category": "meditation",
      "expert_name": "Dr. Smith",
      "duration": 300,
      "thumbnail_url": "...",
      "content_type": "video"
    }
  ],
  "total": 100,
  "page": 1,
  "page_size": 20
}
```

**Swift Implementation:** To be implemented

---

### GET /content/browse
**Purpose:** Browse videos with filters
**Auth Required:** Yes
**Query Parameters:**
- `content_type`: "audio" or "video"
- `page`, `page_size`, `category`, `expert`, `search`

**Swift Implementation:** To be implemented

---

### GET /content/{contentId}
**Purpose:** Get single content metadata
**Auth Required:** Yes
**Response:**
```json
{
  "id": "uuid",
  "title": "...",
  "description": "...",
  "content_type": "video",
  "category": "meditation",
  "expert_name": "Dr. Smith",
  "duration": 300,
  "thumbnail_url": "..."
}
```

**Swift Implementation:** To be implemented

---

## 3. Analytics Endpoints

### POST /api/analytics/video/view
**Purpose:** Track video view
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "content_type": "video",
  "timestamp": "2025-11-29T12:00:00Z"
}
```

**Response:**
```json
{
  "success": true
}
```

**Swift Implementation:** To be implemented

---

### POST /api/analytics/video/complete
**Purpose:** Track video completion
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "content_type": "video",
  "watch_duration": 300,
  "timestamp": "2025-11-29T12:00:00Z"
}
```

**Swift Implementation:** To be implemented

---

### POST /api/analytics/video/progress
**Purpose:** Track playback progress (throttled to every 10 seconds)
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "position": 150,
  "duration": 300
}
```

**Swift Implementation:** To be implemented

---

### POST /api/analytics/video/pause
**Purpose:** Track video pause
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "position": 150
}
```

**Swift Implementation:** To be implemented

---

### POST /api/analytics/video/seek
**Purpose:** Track video seek
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "from_position": 100,
  "to_position": 200
}
```

**Swift Implementation:** To be implemented

---

### POST /api/analytics/video/error
**Purpose:** Track playback error
**Auth Required:** Yes
**Request Body:**
```json
{
  "content_id": "uuid",
  "error_code": "VIDEO_LOAD_FAILED",
  "error_message": "Failed to load video"
}
```

**Swift Implementation:** To be implemented

---

### GET /api/analytics/video/total-views
**Purpose:** Get total view count
**Auth Required:** No
**Response:**
```json
{
  "total_views": 15234
}
```

**Swift Implementation:** To be implemented

---

## 4. Newsletter Endpoint

### POST /api/newsletter/subscribe
**Purpose:** Subscribe to newsletter
**Auth Required:** No
**Request Body:**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "source": "mobile_app"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Subscription successful",
  "subscriber_id": "uuid"
}
```

**Swift Implementation:** To be implemented

---

## Security Considerations

### Token Storage
- **Access tokens:** Store in iOS Keychain (never UserDefaults)
- **Refresh tokens:** Store in iOS Keychain with additional encryption
- **User data:** Can store in UserDefaults (non-sensitive only)

### Request Configuration
```swift
// All authenticated requests should:
let headers = [
    "Content-Type": "application/json",
    "Authorization": "Bearer \(accessToken)"
]

// URLSession configuration
let config = URLSessionConfiguration.default
config.httpCookieStorage = HTTPCookieStorage.shared
config.httpShouldSetCookies = true
```

### Error Handling
```swift
enum APIError: LocalizedError {
    case networkError
    case unauthorized (401)
    case forbidden (403)
    case notFound (404)
    case serverError (500)
    case unknown
}
```

---

## Implementation Priority

### Phase 1 (Current - Hardcoded)
- ✅ Login (admin/admin)
- ✅ Register (mock)
- ✅ Logout (local only)
- ✅ Auth state management

### Phase 2 (Next)
1. Content browsing endpoints
2. Video streaming endpoints
3. Audio streaming endpoints

### Phase 3 (Later)
1. Analytics tracking
2. Profile updates
3. Password reset flow
4. Newsletter subscription

---

## Testing Credentials

**Development:**
- Email: `admin`
- Password: `admin`

**Production:**
- Replace with real backend endpoints
- Remove hardcoded credentials
- Implement proper OAuth flow
