# Where u @ 📍

## Description
"Where u @" is a mobile application designed for iOS platforms that focuses on social connectivity. It allows users to share and discover locations of events and parties based on opinions of people who are already partying. The application provides a platform for real-time location sharing and event discovery, making it easier for users to connect with friends and find exciting events happening around them.

## Tech Stack
- **SwiftUI**: Framework used for designing the app's user interface
- **Firebase Services**:
  - **Firebase Auth**: For user authentication
  - **Firebase Storage**: For storing user-generated content
  - **Firebase Firestore**: NoSQL database for real-time data synchronization

## Current Features

### User Authentication
- Secure sign-up and login functionality using Firebase Auth
- Email and password authentication
- Protected user credentials and data privacy

### Data Storage
- Cloud storage for user-generated content using Firebase Storage
- Secure upload and retrieval of media files

### Database Management
- Real-time data synchronization using Firebase Firestore
- Storage for user profiles, posts, and location data
- Support for complex queries and efficient data retrieval

### UI Components
The app follows a structured development approach:
- **Views**: LoginView, HomeView, ProfileView, etc.
- **Models**: Data structures for users, posts, and locations
- **Services & ViewModels**: Separation of business logic and UI code

## Architecture
The application follows the Model-View-ViewModel (MVVM) pattern for better code organization:
- **Model Layer**: Handles data and business logic
- **View Layer**: Manages UI elements and user interactions
- **ViewModel Layer**: Acts as intermediary between Models and Views

## App Navigation
The app utilizes NavigationView, TabView, and various ViewControllers to create an intuitive user interface designed for frequent, short-term usage with a focus on:
- Easy accessibility
- Single-user focus
- Social sharing capabilities
- Efficient state management

## Roadmap

### Improved Coding Practices
- Enhanced adherence to the MVVM pattern
- Clearer separation of concerns

### Code Refactoring
- Identification and resolution of code smells
- Optimization of code structure for better maintainability

### UI Enhancements
- Custom design elements beyond default iOS components
- Consistent branding with unified color scheme and typography

### Feature Improvements
- Streamlined location creation process
- Bug fixes and stability improvements
- Enhancement of existing features

### Additional Functionalities
- FaceID integration for secure authentication
- Username-based login as an alternative to email

## Getting Started

### Prerequisites
- Xcode 13 or later
- iOS 15.0+ device or simulator
- Firebase account

### Installation
1. Clone the repository
   ```
   git clone https://github.com/[username]/where-u-at.git
   ```
2. Open the project in Xcode
   ```
   cd where-u-at
   open WhereUAt.xcworkspace
   ```
3. Install dependencies using CocoaPods
   ```
   pod install
   ```
4. Configure Firebase
   - Create a new Firebase project
   - Add iOS app to the Firebase project
   - Download and add GoogleService-Info.plist to the project
   - Enable Authentication, Firestore, and Storage services

### Configuration
Update the Firebase configuration in the app to connect to your Firebase project:
1. Place the GoogleService-Info.plist file in the project root
2. Make sure the Bundle ID matches the one registered with Firebase

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue to discuss potential improvements or bug fixes.

## License
[Add appropriate license information here]

## Acknowledgements
- Firebase documentation and community resources
- SwiftUI tutorials and references
- [Add any additional acknowledgements]
