<h1 align="center">Setup</h1>

Just run

```sh
bin/setup
```

Which translates to:

Install/Update the gems.

```sh
bundle install
```

Migrates the test database.

```sh
RACK_ENV=test rake db:migrate
```

Migrates the development database.

```sh
rake db:migrate
```
