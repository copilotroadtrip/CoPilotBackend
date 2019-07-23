# CoPilotBackend [![Build Status](https://travis-ci.com/copilotroadtrip/CoPilotBackend.svg?branch=master)](https://travis-ci.com/copilotroadtrip/CoPilotBackend)

`CoPilotBackend` is a Rails API serving Co-Pilot.

**Co-Pilot** is a full stack application that allows users who are road tripping to keep track of all the cities and towns they
will encounter on their journey. Information regarding the distance and time is displayed between each city. And upon
clicking a particular city users can find weather, hotel, gas, food, and google maps information.


Live CoPilotBackend Rails API Link: https://copilot-backend.herokuapp.com/

Points of Interest Sinatra Microservice: https://github.com/copilotroadtrip/poi-microservice

Frontend React Native application: https://github.com/copilotroadtrip/Co-Pilot


## Contributors

Backend Team
- [Matt Levy](https://github.com/milevy1)
- [William Peterson](https://github.com/wipegup)

Frontend Team
- [Saad Baradan](https://github.com/saadricklamar)
- [Theo Bean](https://github.com/b3an5)


## Tech Stack

* CoPilotBackend - Backend Rails API was built with Rails, RSpec, Postgres, Google Maps API, Darksky API, and Census.gov.
- [Ruby 2.4.1](https://www.ruby-lang.org/en/)
- [Rails 5.2.3](https://rubyonrails.org/)
- Testing with [RSpec](https://rspec.info/)
- Deployed to [Heroku](https://heroku.com)

External data sources:
- [Google Directions API](https://developers.google.com/maps/documentation/directions/intro)
- [Dark Sky API (Weather)](https://darksky.net/dev)
- [US Census Data](https://census.gov)


* The front end was built in Javascript with React-Native. Jest/Enzyme were used for testing and Expo was used as a simulator to build this project.


## Setup

1. Install Ruby 2.4.1.  For instructions on setting up multiple versions of Ruby, we reccomend [rbenv](https://github.com/rbenv/rbenv)

2. Install [Rails 5.2.3](https://rubyonrails.org/)

3. Install database system [PostgreSQL](https://www.postgresql.org/).

4. From your terminal, clone down this repo:

`git clone git@github.com:copilotroadtrip/CoPilotBackend.git`

5. Move into the new directory cloned

`cd CoPilotBackend`

6. Install Ruby gem dependencies

`bundle install`

7. Database creation, migrations, and seed with data about points of interest

`rails db:{create,migrate,seed}`

8. Start your local Rails server

`rails server`

9. Start up your local Redis server

`redis-server`

10. Starts local Sidekiq

`bundle exec sidekiq`


## Testing

- To run test suite with RSpec, move to the root directory and run from your terminal:

`bundle exec rspec`


## [Database Schema](https://dbdiagram.io/d/5d3372fbced98361d6dcd8f6)

<img width="826" alt="CoPilotBackend database schema" src="https://user-images.githubusercontent.com/36040194/61583736-633c8500-aaf9-11e9-9707-992f8164f89f.png">


## Endpoints

### `POST /api/v1/trips`

- Create a new trip with an origin and destination city
- Weather for "origin" is current weather
- Weather for "destination is weather "n" hours from now based on expected driving time
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


### GET `/api/v1/trips`

Required body:
```json
{
  "token": "<trip_token>"
}
```

Three sample responses:
1. Invalid token - Status code 404
```json
{
    "message": "Invalid Token"
}
```

2. Valid token but status pending - Status code 202
```json
{
    "message": "Trip pending"
}
```

3. Valid token and status ready - Status code 200
```json
{
	"data": {
		"places": [{
				"id": 1489,
				"location": {
					"lat": 39.764335,
					"lng": -104.855113
				},
				"name": "Denver",
				"state": "CO",
				"population": 716492,
				"weather": {
					"time": 1563665662,
					"summary": "Foggy",
					"icon": "fog",
					"temperature": 68.79,
					"precipProbability": 0,
					"precipIntensity": 0,
					"windSpeed": 8.37,
					"windGust": 20.91,
					"windBearing": 279
				},
				"sequence_number": 1
			},
			{
				"id": 1490,
				"location": {
					"lat": 39.6572995,
					"lng": -106.089004
				},
				"name": "Silverthorne",
				"state": "CO",
				"population": 4821,
				"weather": {
					"time": 1563665663,
					"summary": "Drizzle",
					"icon": "rain",
					"temperature": 73.77,
					"precipProbability": 1,
					"precipIntensity": 0.013,
					"windSpeed": 7.82,
					"windGust": 16.5,
					"windBearing": 237
				},
				"sequence_number": 2
			},
			{
				"id": 1491,
				"location": {
					"lat": 39.6337775,
					"lng": -106.357158
				},
				"name": "Vail",
				"state": "CO",
				"population": 5450,
				"weather": {
					"time": 1563665664,
					"summary": "Light Rain",
					"icon": "rain",
					"temperature": 78.44,
					"precipProbability": 1,
					"precipIntensity": 0.026,
					"windSpeed": 8.01,
					"windGust": 18.14,
					"windBearing": 243
				},
				"sequence_number": 3
			}
		],
		"legs": [{
			"id": 53,
			"sequence_number": 1,
			"distance": 100,
			"duration_in_hours": 60.0
		}, {
			"id": 54,
			"sequence_number": 2,
			"distance": 150,
			"duration_in_hours": 90.0
		}]
	}
}
```


### PATCH `/api/v1/trips`

Allows for updating trip status to ready.

Required body:
```json
{
  "token": "tripToken",
  "status": "ready"
}
```

Successful response, status: 200
```json
{ "message": "Success" }
```

Unsuccessful response, status 404
```json
{ "message": "Invalid Token" }
```


### POST /api/v1/trip_pois

Body:
```json
"token": <String>,
"trip_poi": {
     "poi_id": "<Integer>"
     "name": "<String>",
     "state": "<String>",
     "population": "<Integer>,"
     "lat": "<Float>",
     "lng": "<Float>",
     "sequence_number": "<Integer>",
     "time_to_poi": "<Float>"
}
```

Successful response, status: 201
```json
{ "message": "Success" }
```

Unsuccessful response, status 404
```json
{ "message": "Invalid Token" }
```


### POST `/api/v1/trip_legs`

Body:

```json
{
  "token": "<string>",
  "distance": "<Integer>",
  "duration": "<Float>",
  "sequence_number": "<Integer>"
}
```

If successful, response, status: 201
```json
 { "message": "Success" }
```

If unsuccessful, response, status: 404
```json
{ "message": "Invalid Token" }
```
