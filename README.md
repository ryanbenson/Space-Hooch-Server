# Space Hooch Server
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/22d81a6654bc4105a6656cff1c7025ee)](https://www.codacy.com/project/ryanbenson/Space-Hooch-Server/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=ryanbenson/Space-Hooch-Server&amp;utm_campaign=Badge_Grade_Dashboard) [![Build Status](https://travis-ci.org/ryanbenson/Space-Hooch-Server.svg?branch=master)](https://travis-ci.org/ryanbenson/Space-Hooch-Server) [![codecov](https://codecov.io/gh/ryanbenson/Space-Hooch-Server/branch/master/graph/badge.svg)](https://codecov.io/gh/ryanbenson/Space-Hooch-Server)

Server for the Space Hooch, 🥃 that is out of this world

# Requirements
* Ruby 2.5
* [Bundler installed](https://bundler.io/)

# Development
The API is all run inside of `api.rb`. This is using `rspec` so please maintain the tests in `spec/*`. It is configured with [Travis CI](https://travis-ci.org/) for CI, [Codacy](https://codacy.com/) for Static Analysis, and [CodeCov](https://codecov.io/) for code coverage. So you'll know if you messed it up.

# APIs
_GET_ `/api/ping`

Will return a `pong` in JSON

_GET_ `api/satellites`

Will return all satellites

_PUT_ `/api/satellites`

Is what updates the data. Requirements:
* `file` field that is a JSON type file
It will return a 400 if there is no file, or if the file isn't JSON. It will process and return a 200 if successful

If there is no satellite with the `satellite_id`, it will be created

If an existing satellite_id has already been created, it will merge the data, and
update the data

## Sample JSON format
Here is a sample JSON data that should be provided through a file in the above API call to update the data
```json
{
  "telemetry_timestamp": 1534198007,
  "satellite_id": 1,
  "barrels": [
    {
      "batch_id": 1,
      "last_flavor_sensor_result": "woody",
      "status": "aging",
      "errors": []
    },
    {
      "batch_id": 2,
      "last_flavor_sensor_result": "error",
      "status": "error",
      "errors": ["RUD - barrel has exploded"]
    },
    {
      "batch_id": 3,
      "last_flavor_sensor_result": "spicy with a hint of radiation",
      "status": "ready",
      "errors": []
    }
  ]
}

```
