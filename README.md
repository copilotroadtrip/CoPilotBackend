# Co-Pilot


**Co-Pilot** is a full stack application that allows users who are road tripping to keep track of all the cities and towns they
will encounter on their journey. Information regarding the distance and time is displayed between each city. And upon
clicking a particular city users can find weather, hotel, gas, food, and google maps information.


Live CoPilotBackend API Link: [https://copilot-backend.herokuapp.com/]

Frontend React Native application: [https://github.com/copilotroadtrip/Co-Pilot]


## Tech Stack

* The back end was built with Rails, RSpec, Postgres, Google Maps API, Darksky API, and Census.gov.

* The front end was built in Javascript with React-Native. Jest/Enzyme were used for testing and Expo was used as a simulator to build this project.

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


## [Database Schema](https://dbdiagram.io/d/5d3372fbced98361d6dcd8f6)

<img width="826" alt="CoPilotBackend database schema" src="https://user-images.githubusercontent.com/36040194/61583736-633c8500-aaf9-11e9-9707-992f8164f89f.png">


## Endpoints

## `POST /api/v1/trips`

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
		"trip_token": "ZxVy6TFrafZNyLoUjckMxdkH",
		"places": [{
				"id": 1739,
				"location": {
					"lat": 39.764335,
					"lng": -104.855113
				},
				"name": "Denver",
				"state": "CO",
				"population": 716492,
				"weather": {
					"time": 1563587675,
					"summary": "Partly Cloudy",
					"icon": "partly_cloudy_day",
					"temperature": 93.84,
					"precipProbability": 0,
					"precipIntensity": 0,
					"windSpeed": 4.98,
					"windGust": 11.03,
					"windBearing": 76
				},
				"sunrise_time": 1563709708,
				"sunset_time": 1563675761
			},
			{
				"id": 1740,
				"location": {
					"lat": 47.608715000000004,
					"lng": -122.339798
				},
				"name": "Seattle",
				"state": "WA",
				"population": 744955,
				"weather": {
					"time": 1563656400,
					"summary": "Clear",
					"icon": "clear_day",
					"temperature": 74.52,
					"precipProbability": 0,
					"precipIntensity": 0,
					"windSpeed": 8.77,
					"windGust": 10.46,
					"windBearing": 350
				},
				"sunrise_time": 1563712401,
				"sunset_time": 1563681451
			}
		],
		"legs": [{
			"distance": "1316 mi",
			"duration_in_hours": 19.673055555555557,
			"id": 1
		}]
	}
}
```


## PATCH `/api/v1/trips`

Allows for updating trip status to ready.

Required body:
```json
"token": "tripToken",
"status": "ready"
```

Successful response, status: 200
```json
{ "message": "Success" }
```

Unsuccessful response, status 404
```json
{ "message": "Invalid Token"}
```

## POST /api/v1/trip_pois

Body:
```json
"token": <String>,
"trip_poi": {
     "poi_id": <Integer>
     "name": <String>,
     "state": <String>,
     "population": <Integer>
     "lat": <Float>,
     "lng": <Float>
     "sequence_number": <Integer>,
     "time_to_poi": <Float>
}
```

Successful response, status: 201
```json
{ "message": "Success" }
```

Unsuccessful response, status 404
```json
{ "message": "Invalid Token"}
```
