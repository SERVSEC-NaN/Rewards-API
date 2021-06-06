<h1 align="center">API Reference</h1>

Table of contents
=================

* [Installation](#installation)
* [Execute](#execute)
* [Test](#test)
* [Routes](#routes)
  * [/subscribers](#subscribers)
  * [/promoters](#promoters)
  * [/promotions](#promotions)
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

## Subscibers

Create a subscriber

```http
POST api/v1/subscribers
```

| Parameter      | Type      | Description   |
| :------------- | :---------| :------------ |
| `Phone`        | `integer` | **Required**. |

Make a subscription (subscriber + promoter)

```http
POST api/v1/subscribers/[subscriber_id]/subscribe
```

| Parameter | Type      | Description   |
| :-------- | :-------- | :------------ |
| `id`      | `uuid`    | **Required**. |


Get details of a single subscriber

```http
GET api/v1/subscribers/[subscriber_id]
```

Get list of all subscribers

```http
GET api/v1/subscribers/
```

## Promoters

Create a new promoter

```http
POST api/v1/promoters/
```

| Parameter      | Type     | Description   |
| :------------- | :------- | :------------ |
| `Name`         | `string` | **Required**. |
| `Organization` | `string` | **Required**. |
| `Email`        | `string` | **Required**. |

Create a promotion for a promoter

```http
POST api/v1/promoters/[promoter_id]/promotions
```

| Parameter       | Type     | Description   |
| :-------------- | :------- | :------------ |
| `Title`         | `string` | **Required**. |
| `Description`   | `string` | **Required**. |

Get a promotion's details of a specific promoter

```http
GET api/v1/promoters/[promoter_id]/promotions/[promotion_id]
```

Get all promotions of a specific promoter

```http
GET api/v1/promoters/[promoter_id]/promotions/
```

Get details of a specific promoter

```http
GET api/v1/promoters/[promoter_id]
```

Get all promoters

```http
GET api/v1/promoters/
```

## Promotions

Get all promotions

```http
GET api/v1/promotions/
```

## Tags

Create a tag

```http
POST api/v1/tags
```

| Parameter | Type     | Description   |
| :-------- | :------- | :------------ |
| `name`    | `string` | **Required**. |

Add a tag to a promotion

```http
POST api/v1/tags/[tag_id]/promotion
```

| Parameter | Type      | Description   |
| :-------- | :-------- | :------------ |
| `id`      | `integer` | **Required**. |

Get specific tag

```http
GET api/v1/tags/[tag_id]
```

Get all tags

```http
GET api/v1/tags/
```
