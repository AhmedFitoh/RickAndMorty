# Rick and Morty Character Viewer

## Overview
An iOS application that showcases characters from the Rick and Morty universe using their public API. The app demonstrates modern iOS development practices, combining UIKit and SwiftUI in a clean MVVM-C architecture.

## Features
- Character list with pagination (20 characters per page)
- Status-based filtering (Alive, Dead, Unknown)
- Detailed character view
- Hybrid UI implementation (UIKit + SwiftUI)
- Clean architectural patterns
- No external dependencies

## Architecture
The app follows the MVVM-C (Model-View-ViewModel-Coordinator) architectural pattern:
- **Model**: Represents the data and business logic
- **View**: UI components (UIKit and SwiftUI)
- **ViewModel**: Handles the presentation logic and state management
- **Coordinator**: Manages navigation flow

## Technical Highlights
- Programmatic UI without storyboards
- Combine framework for reactive state management
- Async/await for network operations
- Protocol-oriented network layer
- SwiftUI integration in UIKit
- Proper error handling
- Infinite scrolling with pagination
- Proper memory management

## Requirements
- iOS 18.0+
- Xcode 16.1+
- Swift 5.0+

## Installation
1. Clone the repository:
```bash
git clone https://github.com/yourusername/RickAndMorty.git
```
2. Open RickAndMorty.xcodeproj in Xcode
3. Build and run the project

## Acknowledgments
[Rick and Morty API](https://rickandmortyapi.com/) for providing the data

## License
This project is licensed under the MIT License - see the LICENSE file for details

