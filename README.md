# Weather-Responsive Dynamic Homepage

A Flutter application featuring a dynamic home page that adapts its theme and UI elements based on real-time weather data. The application demonstrates implementation of location services, weather API integration, and dynamic UI components.

## Features

### Core Features
- Location-based weather data fetching
- Dynamic theme adaptation based on weather conditions 
- Dynamic banner system with AppWrite integration
- Pull-to-refresh functionality
- Local storage for user preferences
- City-based weather search functionality

### Technical Features
- Responsive design implementation
- GetX state management
- Custom shimmer loading effects
- AppWrite backend integration
- Real-time weather updates
- Animated UI transitions

## Why AppWrite Instead of Firebase?

I initially did the setup for Firebase but later found out that Firebase storage is now a part of Firebases' Blaze Plan. 
I did not want to upgrade to blaze plan that's why I used AppWrite as an alternative for it.

## Project Setup

### Prerequisites
- Flutter SDK (latest stable version)
- AppWrite account and server setup
- IDE with Flutter support

### Installation Steps

1. Clone the repository
2. Install dependencies
3. Configure AppWrite
  - Although this information should be kept in a env file that should not be pushed to 
    github but as this was a demo project that's why I directly put in the credentials and api key in the project itself.

## Things Implemented

### Location Services

Implemented location permission handling
Device coordinate-based weather data fetching
Location data caching mechanism

### User Interface

Shimmer loading animations
Weather-responsive components
State transition animations
Dark mode implementation

### Data Management

AppWrite storage integration for dynamic banner management
Robust error-handled API architecture
Local data persistence for user preferences
GetX state management for efficient state updates

### Performance Optimizations

Lazy loading of weather data
Optimized asset loading
Minimal rebuild strategy using GetX

### Future Improvements

Enhanced weather animations
AppWrite asset caching
Unit test implementation
Multilingual support
