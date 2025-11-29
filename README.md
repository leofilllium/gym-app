# RAFIS GYM - Fitness Workout App

A comprehensive fitness application offering workout videos, training programs, and exercise routines with multi-language support and in-app purchases.

<img width="280" alt="logo 3" src="https://github.com/user-attachments/assets/93c2d8cc-cfed-46c4-b5fa-998d19de70a2" />


## 📱 Features

### 🔐 Authentication & Access
- **Regional Access Control**: Automatic detection of user's location
- **Uzbekistan Users**: UUID-based authentication system
- **International Users**: In-app purchase for full access
- **Secure Validation**: Server-side purchase and subscription validation

### 🎯 Workout Content
- **Categorized Workouts**: Organized by fitness goals and body types
- **Video Training**: High-quality exercise videos with full-screen playback
- **Multi-level Navigation**: Categories → Subcategories → Videos
- **Search Functionality**: Quick search across all workout videos

### 🌍 Multi-language Support
- **English** - Complete interface translation
- **Russian** - Русский интерфейс
- **Uzbek** - O'zbek tilidagi interfeys

### 💰 Purchase System
- **One-time Purchase**: Unlock all content permanently
- **Subscription Validation**: Periodic server-side license checks
- **Restore Purchases**: Recover previous purchases on new devices
- **Secure Transactions**: Verified through official app stores

## 🛠 Technical Stack

### Core Technologies
- **Flutter** - Cross-platform framework
- **Dart** - Programming language
- **Cupertino Design** - iOS-style UI components

### Key Dependencies
- `in_app_purchase` - Purchase handling
- `video_player` & `chewie` - Video playback
- `shared_preferences` - Local storage
- `http` - API communication
- `device_info_plus` - Device detection
- `cached_network_image` - Image caching

## 📸 Screenshots

### Authentication & Purchase
| Language Selection | Purchase Screen |
|--------------------|-----------------|
| <img width="280" alt="IMG_3043" src="https://github.com/user-attachments/assets/18415584-dd92-42f5-add4-703f4bb04ccb" /> | <img width="280" alt="IMG_2610" src="https://github.com/user-attachments/assets/1d574589-36c8-49b5-a3b0-0d944ddc366c" /> |

### Main Interface
| Workout Categories | Category View | Video Player |
|--------------------|---------------|--------------|
| <img width="280" alt="IMG_3044" src="https://github.com/user-attachments/assets/24f136bb-1264-4d5a-bd8e-439ce76712aa" /> | <img width="280" alt="IMG_3045" src="https://github.com/user-attachments/assets/4216e3aa-bf28-4c08-bbbb-fb58aafc0740" /> | <img width="560" alt="IMG_3047" src="https://github.com/user-attachments/assets/9a473e5c-e05c-4344-9190-1523f5859166" /> |

### Navigation
| Search | Nested Categories |
|--------|-------------------|
| <img width="280" alt="IMG_3046" src="https://github.com/user-attachments/assets/2493d7af-24a8-4d14-9c7c-d517e43e3691" /> | <img width="280" alt="IMG_3048" src="https://github.com/user-attachments/assets/f751af71-0fd3-4d21-898f-5a8cb3ac5bbc" /> |

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.0+
- iOS 13.0+ or Android 6.0+
- App Store Connect account (iOS) or Google Play Console (Android)

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/leofilllium/gym-app.git
   cd gym-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure platform-specific settings**

   **iOS:**
   - Add In-App Purchase capability in Xcode
   - Configure App Store Connect with product IDs

   **Android:**
   - Update `android/app/src/main/AndroidManifest.xml`
   - Configure billing permissions

4. **Configure backend endpoints**
   - Update API endpoints in the code
   - Set up purchase validation server

5. **Run the application**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Backend API
The app requires a backend server for:
- UUID validation (`/validate`)
- Purchase verification (`/verify_purchase`)
- Subscription validation (`/validate_subscription`)

### Product Configuration
- **Android**: Product ID `full_access`
- **iOS**: Product ID `full_access_full_access`

### Localization
Translation files are structured in JSON format with support for:
- English (default)
- Russian
- Uzbek

## 💡 Key Features Implementation

### Purchase Flow
```dart
// Purchase initialization
final bool isAvailable = await InAppPurchase.instance.isAvailable();
final ProductDetailsResponse response = 
    await InAppPurchase.instance.queryProductDetails({_productId});

// Purchase execution
await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
```

### Video Player
```dart
// Video controller setup
_videoPlayerController = VideoPlayerController.network(encodedUrl);
_chewieController = ChewieController(
  videoPlayerController: _videoPlayerController,
  autoPlay: true,
  looping: false,
  allowFullScreen: true,
);
```

### Regional Access Control
```dart
// Location-based access
_isUserInUzbekistan = await CountryService.isUserInUzbekistan();
if (_isUserInUzbekistan == true) {
  // UUID authentication
} else {
  // Purchase required
}
```

## 🎨 UI/UX Design

- **Dark Theme**: Optimized for workout environments
- **Cupertino Design**: Native iOS feel
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Enhanced user experience

## 📊 Performance

- **Lazy Loading**: Efficient category and video loading
- **Image Caching**: Optimized asset loading
- **Video Preloading**: Smooth playback experience
- **Memory Management**: Proper disposal of controllers

## 🔒 Security

- **Purchase Token Validation**: Server-side receipt verification
- **UUID Encryption**: Secure authentication
- **Subscription Checks**: Regular license validation
- **Secure Storage**: Encrypted local data

---
