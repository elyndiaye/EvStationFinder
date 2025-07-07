# EvStationFinder

A mobile application that allows users to find electric vehicle charging stations based on a ZIP code, using the NREL API

## 📱 App Preview

![App Preview](https://github.com/elyndiaye/EvStationFinder/raw/main/assets/demo.gif)

## 🚀 Features

- 🔍 Search for charging stations by ZIP code
- 📍 View station locations and details
- ⚠️ Displays a message if no stations are found
- 🛠️ MVVM Architecture
- 🛠️ Custom spacing and strings management

## 🚀 Setup & Run Instructions
- Xcode 16 or later
- NREL API Key ([Get yours here](https://developer.nrel.gov/docs/api-key/))

1. Clone the repository:
 - git clone https://github.com/elyndiaye/EvStationFinder.git
 - cd EvStationFinder
2. Add your NREL API Key:
- Open the project in Xcode.
- Navigate to NetworkService.swift.
- Replace <your_api_key_here> with your actual NREL API Key.
3. Run: 
- Build and run (Cmd + R)


## 🛠️ Tools

- Xcode 16.2
- Swift UI
- MVVM / SOLID
- User Defaults
- Async/Await
- MapKit
- Dependency Injection
- Unit tests

## Brief MVVM Architecture

- Model: 
  - Structure of charging station data
- ViewModel:  
  - Handles business logic and API integration.  
  - Uses `@Published` properties for state changes.  
  - Annotated with `@MainActor` to ensure thread safety.
- View:  
  - Binds @StateObject to HomeViewModel.  
  - Update the UI based on viewModel changes.
