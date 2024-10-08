# cineScope

## Overview

This repository contains an iOS project that uses TMDB ([The Movie Database](https://developer.themoviedb.org/docs/getting-started)) API.
User can discover movies, search contents and manage favorites in this app. 
This project demonstrates the implementation of the VIPER with a modular structure using Swift Package Manager (SPM).

## Features

- **VIPER Architecture**: The project follows the VIPER design pattern to ensure a clean separation of concerns.
- **Combine Framework**: Utilizes Combine for handling asynchronous events and data binding.
- **Alamofire**: Network layer developed with Alamofire.
- **Compositional Layout**: Implements modern collection view layouts for complex UI designs.
- **Diffable Data Source**: Uses Diffable Data Source to manage collection view data with ease and efficiency.
- **Modular Design**: The project is structured using Swift Package Manager (SPM) for better modularity and reusability.

### Sample of Autolayout:
<img width="1328" alt="autoLayout" src="https://github.com/user-attachments/assets/6440ff71-a7fd-4340-9bfa-b0e847e1562d">

### Sample of project file organization:
<img src="https://github.com/user-attachments/assets/1212354a-cf2d-4d21-a266-26667f6fe3e1" alt="files" width="500"/>

## Modules

### Completed

- **Splash Module**: Handles the initial loading sequence of the application. A Lottie animation used for the transaction duration from splash to tabBar screens.

https://github.com/user-attachments/assets/cb964406-b360-4dcc-a761-4f5718cd18c0
- **Home Module**: The main interface displaying a list of items using `Compositional Layout` and `Diffable Data Source`. 

https://github.com/user-attachments/assets/1e216f40-882e-44d8-a5b8-d1eb6e1f5c3d


- **Movie Detail Module**: Selected movie's detail informations content screen. `UIScrollView` and separated section views used. The items are interactable: it routes users to search screens according to the selected item's type.

https://github.com/user-attachments/assets/f09f4656-eb5b-4638-8fab-3cea7fc66c6c

- **Search Module**: Instead of discovering content this page locates on TabBar's middle screen. It show the last discovered movie's keywords for shortcuting of search with query. Therefore, user can use the UISearchBar component for typing needed qeury text for searching. When the action taken the Search screen (some kind of Product List Page (PLP)) opens with pagination logic. On this PLP page Diffable Data Sources used for dynamic value changes.

https://github.com/user-attachments/assets/2be8b08a-cba3-425d-bd4a-c846821c5430

- **Favorites Module**: A list screen which is shows the favorite movies of user. `Diffable Data Source` used for dynamic data changes. In addition the `UICollectionLayoutListConfiguration` is used for the swipe to un-favorite action. The data is simply stored with `UserDefaults`.

https://github.com/user-attachments/assets/db730655-c0db-40d9-bbdd-840476a02336

## Unit Test

The `Home` module of the CineScope project includes comprehensive unit tests to ensure the robustness and reliability of its functionalities. The unit tests cover various aspects of the Home module, including:

-	Content Fetching: Validates the correct fetching and handling of movies, movie genres, people lists, and category data.
-	Routing: Ensures that navigation actions trigger the expected routes and interactions.
-	UI Interaction Flows: Tests user interface interactions, such as selection of categories and genres, to confirm they result in the correct behavior.

### Testing Frameworks and Tools

-	XCTest: Utilized for creating and managing unit tests.
-	Combine: Used for handling asynchronous events and data streams within the tests with help of the `XCWaiter`.
-	Mocking: Mock objects and stubs are employed to simulate and control various scenarios and dependencies. Local JSON files used for the simulating fetched datas.

## Dependicies

- [**Alamofire**](https://github.com/Alamofire/Alamofire): Elegant HTTP Networking in Swift
- [**Atlantis**](https://github.com/ProxymanApp/atlantis): Capture HTTP/HTTPS, and Websocket from iOS app without proxy.
- [**IQKeyboardManager**](https://github.com/hackiftekhar/IQKeyboardManager): Codeless drop-in universal library allows to prevent issues of keyboard sliding up and cover UITextField/UITextView. Neither need to write any code nor any setup required and much more.
- [**KingFisher**](https://github.com/onevcat/Kingfisher): A lightweight, pure-Swift library for downloading and caching images from the web.
- [**Lottie**](https://github.com/airbnb/lottie-ios): An iOS library to natively render After Effects vector animations
- [**PanModal**](https://github.com/slackhq/PanModal): An elegant and highly customizable presentation API for constructing bottom sheet modals on iOS.
