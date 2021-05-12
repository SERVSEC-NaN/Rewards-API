<h1 align="center">API Documentation</h1>

## Routes

All routes return Json

- GET  `/`: Root route shows if Rewards API is running.
- GET  `api/v1/{subscriber,promoter,subscription,tag}/`: returns all from model
- GET  `api/v1/{subscriber,promoter,subscription,tag}/[id]`: returns single entry
- POST  `api/v1/{subscriber,promoter,subscription,tag}/`: Uploads model data

## Install

```shell
bundle install
```

Setup development database once:

```shell
bundle exec rake db:migrate
```

## Execute

Run this API using:

```shell
bundle exec rackup
```

## Test

Setup test database once:

```shell
RACK_ENV=test bundle exec rake db:migrate
```

Run the test specification script in `Rakefile`:

```shell
bundle exec rake spec
```
