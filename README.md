# cineScope

## Overview

This repository contains an iOS project that uses TMDB ([The Movie Database](https://developer.themoviedb.org/docs/getting-started)) API.
User can discover movies, search contents and manage favorites in this app. 
This project demonstrates the implementation of the VIPER with a modular structure using Swift Package Manager (SPM).

## Features

- **VIPER Architecture**: The project follows the VIPER design pattern to ensure a clean separation of concerns.
- **Combine Framework**: Utilizes Combine for handling asynchronous events and data binding.
- **Alamofire** based Network layer.
- **Compositional Layout**: Implements modern collection view layouts for complex UI designs.
- **Diffable Data Source**: Uses Diffable Data Source to manage collection view data with ease and efficiency.
- **Modular Design**: The project is structured using Swift Package Manager (SPM) for better modularity and reusability.

### Sample of project file organization:
<img src="https://github.com/user-attachments/assets/1212354a-cf2d-4d21-a266-26667f6fe3e1" alt="files" width="500"/>

## Modules

### Completed

- **Splash Module**: Handles the initial loading sequence of the application.

https://github.com/user-attachments/assets/cb964406-b360-4dcc-a761-4f5718cd18c0
- **Home Module**: The main interface displaying a list of items using Compositional Layout and Diffable Data Source.

https://github.com/user-attachments/assets/994472dc-a90f-412e-8a81-21034d136bd9

### Work In Progress

- **Movie Detail Module**: Will display detailed information about selected movies.
- **Search Module**: Will allow users to search for movies and other content.
- **Favorites Module**: Will manage the user's favorite movies.

## Upcoming Features

- **Unit Tests**: Comprehensive unit tests will be added to ensure the reliability and robustness of the code.
