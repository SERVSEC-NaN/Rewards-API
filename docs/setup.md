<h1 align="center">Setup</h1>

Don't forget to update the gems

`bundle install`

Firstly, migrate the database

`RACK_ENV=test rake db:migrate`

## Run unit tests

`RACK_ENV=test bundle exec rake api_test`
