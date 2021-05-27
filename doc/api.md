<h1 align="center">API Documentation</h1>

Table of contents
=================

* [Installation](#installation)
* [Execute](#execute)
* [Test](#test)
* [Routes](#routes)
  * [/](#root)
  * [/subscribers](#subscribers)
  * [/promoters](#promoters)
  * [/tags](#tags)

Installation
============

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

Routes
============

## Root

`/api/v1/`

## Subscibers

> /api/v1/subscribers

Create a subscriber

`POST api/v1/subscribers`

Make a subscription (subscriber + promoter)

`POST api/v1/subscribers/[subscriber_id]/subscribe/[promoter_id]`

Get details of a single subscriber

`GET api/v1/subscribers/[subscriber_id]`

Get list of all subscribers

`GET api/v1/subscribers/`

## Promoters

> /api/v1/promoters

Create a new promoter

`POST api/v1/promoters/`

Create a promotion for a promoter

`POST api/v1/promoters/[promoter_id]/promotions`

Get a promotion's details of a specific promoter

`GET api/v1/promoters/[promoter_id]/promotions/[promotion_id]`

Get all promotions of a specific promoter

`GET api/v1/promoters/[promoter_id]/promotions/`

Get details of a specific promoter

`GET api/v1/promoters/[promoter_id]`

Get all promoters

`GET api/v1/promoters/`

## Tags

> /api/v1/tags

Create a tag

`POST api/v1/tags`

Add a tag to a promotion

`POST api/v1/tags/[tag_id]/promotion/[promotion_id]`

Get specific tag

`GET api/v1/tags/[tag_id]`

Get all tags

`GET api/v1/tags/`
