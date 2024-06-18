# Find Places

A simple iOS application that allows users to search for nearby places based on their current location using MapKit. The app displays the distance to each place and provides a calling feature for easy contact.

## Features

- **Search Nearby Places**: Users can search for various types of places (e.g., restaurants, cafes, gas stations) near their current location.
- **Display Distance**: Calculates and displays the distance from the user’s current location to the selected nearby places.
- **Contact Information**: Displays the contact number of each nearby place, allowing users to call directly from the app.


## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/mohd-kasif/Find-Places.git
    ```
2. Build and run the project on your simulator or device.

## Usage

1. Allow the app to access your location when prompted.
2. Use the search bar to find nearby places of interest.
3. View the list of results, which includes the name, distance, and contact number for each place.
4. Tap on a place to see more details and call the provided contact number if needed.

## Technical Details

- **MapKit Integration**: Utilizes `MKMapView` for displaying the map and user’s current location.
- **Location Services**: Uses `CLLocationManager` to get the user's current location.
- **Search Functionality**: Implements `MKLocalSearch` to find nearby places based on user input.
- **Calling Feature**: Integrates the calling feature using `UIApplication.shared.open(URL(string: "tel://\(phoneNumber)")!)`.
