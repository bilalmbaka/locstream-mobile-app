# locstream

**Locstream is a real-time location sharing and monitoring app designed to help users keep track of friends, family, or team members. It provides secure authentication, profile management, and features for adding watchers and watching others, all built with Flutter for cross-platform support.**

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- **User Authentication**: Secure signup, login, and account verification using OTP.
- **Profile Management**: Edit and update user profiles, including profile pictures.
- **Location Sharing**: Share your location with selected watchers and view their locations in real time.
- **Watchers & Watching**: Add new watchers, manage who you are watching, and see lists of both.
- **Settings**: Customize app preferences and privacy settings.
- **Offline Support**: Access profile and watcher data even when offline.
- **Cross-Platform**: Runs on Android, iOS, Web, Windows, macOS, and Linux.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

### Prerequisites

- Flutter SDK: 3.x.x or latest ([Install Flutter](https://docs.flutter.dev/get-started/install))
- Dart SDK: 3.x.x or latest (included with Flutter)
- Android Studio or VS Code (recommended IDEs)
- Xcode (for iOS development)
- API Keys: If using map or location services, add your Google Maps API Key to the appropriate configuration files.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/your-username/locstream-app.git
    cd locstream-app
    ```
2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```
3.  **Run the app:**
    ```bash
    flutter run
    ```
    > For multiple flavors or configurations, use:  
    > `flutter run --flavor <flavor-name>`

## Usage

1. **Sign Up / Log In:**  
   Launch the app and create a new account or log in using your email and OTP verification.

2. **Edit Profile:**  
   Navigate to the profile section to update your details and profile picture.

3. **Add Watchers:**  
   Use the "Add New Watcher" screen to invite others to watch your location.

4. **View Watchers & Watching:**  
   Access the drawer to see who you are watching and who is watching you.

5. **Share Location:**  
   Enable location sharing to allow your watchers to see your real-time location.

6. **Settings:**  
   Adjust privacy and notification preferences in the settings screen.

![Screenshot](assets/screenshots/home.png)  
_Home screen showing watcher list and location sharing._

## Project Structure

A brief overview of how the project is structured:

```
locstream-app/
|- android/          # Android specific files
|- ios/              # iOS specific files
|- lib/              # Main Flutter application code
|  |- main.dart      # Main application entry point
|  |- core/          # Core services, utilities, constants
|  |- data/          # Data layer (models, repositories, data sources)
|  |- views/         # UI layer (screens, widgets)
|  |- view_models.dart # Riverpod providers and state management
|- test/             # Unit and widget tests
|- pubspec.yaml      # Project dependencies and metadata
|- README.md         # This file
...
```

## Contributing

Contributions are welcome! If you'd like to contribute, please follow these steps:

1.  Fork the Project
2.  Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the Branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

Please make sure to update tests as appropriate.

## License

This project is **Unlicensed**.  
Anyone is free to clone, use, modify, and distribute this repository and its contents for any purpose, without restriction.

## Contact

Bilal Mbaka - mbakabilal@yahoo.com
