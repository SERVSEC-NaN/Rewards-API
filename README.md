<h1 align="center">REWARDS</h1>

<br/>

<p align="center">
Your time and personal information is valuable to you. It is also
valuable to business. Let them <strong>reward</strong> you for sharing those things
with them.
</p>

<br/>

<h3 align="center">
<a href="doc/api.md">API</a> | <a href="doc/entity-relationship.md">Entity Relationship</a> | <a href="doc/course.md">SERVSEC</a> | <a href="https://github.com/SERVSEC-NaN/Rewards-UI-Ruby" target=”_blank”>Web UI</a></h3>

<br/>

<h3 align="center">Setup</h3>

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
RACK_ENV=test bundle exec rake db:migrate
```

Migrates the development database.

```sh
bundle exec rake db:migrate
```
