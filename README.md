# MovieApp
## Introduction
MovieApp is a simple iOS application that allows users to search for movies, favorite them, and view their favorites in a separate screen. The app uses the OMDB API to fetch movie details and UserDefaults for adding and removing movies from favourites.

## Features
* Search Movies: Search for movies by title.
* Favorite Movies: Add movies to your favorites list.
* Remove from Favorites: Remove movies from your favorites list.
* Three Screens:
  * Movie Screen: Displays a list of action movies and allows searching.
  * MovieDetails Screen: Displays the details of selected movie.
  * Favorites Screen: Displays a list of favorited movies.

## Prerequisites
To run the app, you need an API key from OMDB. You can obtain one by signing up at the OMDB API website.

## Setup
1.Clone the Repository

2.In the root of the project, create a file named Secrets.plist. Add the following key-value pair to it:
key : OMDB_API_Key , value: Your_OMDB_API_Key 
Replace Your_OMDB_API_Key with your actual API key.

3.Run the App:
Open the project in Xcode and build the app. You should be able to run it on a simulator or device.

