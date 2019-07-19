# CoPilotBackend

Rails API for CoPilot - Road trip data consolidated in one application

Live API Link: [https://copilot-backend.herokuapp.com/]
Frontend React Native application: [https://github.com/copilotroadtrip/Co-Pilot]


## Tech Stack

Backend
- Rails 5.2.3

Frontend
- React Native

## Code Status

[![Build Status](https://travis-ci.com/copilotroadtrip/CoPilotBackend.svg?branch=master)](https://travis-ci.com/copilotroadtrip/CoPilotBackend)


## Contributors

Backend Team
- [Matt Levy](https://github.com/milevy1)
- [William Peterson](https://github.com/wipegup)

Frontend Team
- [Saad Baradan](https://github.com/saadricklamar)
- [Theo Bean](https://github.com/b3an5)


## Setup

1. From your terminal, clone down this repo:
`git clone git@github.com:copilotroadtrip/CoPilotBackend.git`

2. Install Ruby gem dependencies
`bundle install`

3. Database creation, migrations, and seed with data about points of interest
`rails db:{create,migrate,seed}`

4. Start up your local Redis server
`redis-server`

5. Starts local Sidekiq
`bundle exec sidekiq`


## Database Schema

<img width="826" alt="CoPilotBackend database schema" src="https://user-images.githubusercontent.com/36040194/61190610-5aad0000-a65c-11e9-8d59-1ae6eaa262bb.png">


## Endpoints

`POST /api/v1/trips`

- Create a new trip with an origin and destination city
- Weather information comes from from [Dark Sky API](https://darksky.net/dev/docs)
- Weather for "origin" is current weather
- Weather for "destination is weather "n" hours from now based on expected driving time

- Directions (time / distance) from [Google Directions API](https://developers.google.com/maps/documentation/directions/start)
- Population from points of interest come from:  `<Insert source of of POI data>`
- Return "0" if POI is not in database

Example body:
```json
{
 "origin": "Denver,CO",
 "destination": "Vail,CO"
}
```

Example Response:
```json
{
    "data": {
        "trip_token": "random_string_token",
        "places": [
            {
                "location": {
                    "lat": 39.7411598,
                    "lng": -104.9879112
                },
                "name": "Denver, CO, USA",
                "state": "CO",
                "population": 716492,
                "weather": {
                    "time": 1563574427,
                    "summary": "Partly Cloudy",
                    "icon": "partly_cloudy_day",
                    "temperature": 99.4,
                    "precipProbability": 0,
                    "precipIntensity": 0,
                    "windSpeed": 4.85,
                    "windGust": 9.73,
                    "windBearing": 26
                }
            },
            {
                "location": {
                    "lat": 39.6400516,
                    "lng": -106.3749391
                },
                "name": "Vail, CO 81657, USA",
                "state": "CO",
                "population": 5450,
                "weather": {
                    "time": 1563580800,
                    "summary": "Clear",
                    "icon": "clear_day",
                    "temperature": 82.5,
                    "precipProbability": 0,
                    "precipIntensity": 0,
                    "windSpeed": 9.07,
                    "windGust": 14.96,
                    "windBearing": 283
                }
            }
        ],
        "legs": [
            {
                "distance": "97.1 mi",
                "duration_in_hours": 1.7422222222222221
            }
        ]
    }
}
```
