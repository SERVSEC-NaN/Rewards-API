<h1 align="center">API Reference</h1>

Table of contents
=================

* [Installation](#installation)
* [Execute](#execute)
* [Test](#test)
* [Routes](#routes)
  * [/auth/authenticate](#authentication)
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
make setup
```

## Execute

Run this API using:

```shell
make up
```

## Test

Run the test specification script in `Rakefile`:

```shell
make test
```

Routes
============

## Authentication

```http
POST api/v1/auth/authenticate
```

| Parameter  | Type      | Description   |
| :----------| :---------| :------------ |
| `email`    | `string`  | **Required**. |
| `password` | `string`  | **Required**. |

Example input

```json
{
 "email": "me@email.com",
 "password": "mystrongpassword"
}
```

Example output

```json

{
    "type": "authenticated_subscriber",
    "attributes": {
        "account": {
            "id": "33f2ba3d-7bcc-2b4f-8e41-f2e9df10c5a2",
            "email": "me@email.com"
        },
        "auth_token": "VRLzfMHqatcMjVR2Va-ATZ9VgCWtYZq8bv3f7hYtKuyaqJVXA5HdcGk9dZWfDg67YnBrFGNkUHn6crwWCR-k8UDM_fn1sgwLghuhA4YnZhTlbFqKcJnuSKViTxHwIoXTDBEeNjJBOvR7GG74WfopmaROw2K4uKejRK89APDQtG4tty62i-2E1m1kpBU0xw=="
    }
}
```

## Subscibers

Create a subscriber

```http
POST api/v1/subscribers
```

| Parameter | Type      | Description   |
| :---------| :---------| :------------ |
| `email`   | `string` | **Required**. |

Make a subscription (subscriber + promoter)

```http
POST api/v1/subscribers/{subscriber_id}/subscribe
```

| Parameter | Type      | Description   |
| :-------- | :-------- | :------------ |
| `id`      | `uuid`    | **Required**. |


Get details of a single subscriber

| Parameter               | Type     | Description   |
| :---------------------- | :------- | :------------ |
| `Authorization: Bearer` | `string` | **Required**. |

```http
GET api/v1/subscribers/{subscriber_id}
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
| `name`         | `string` | **Required**. |
| `organization` | `string` | **Required**. |
| `email`        | `string` | **Required**. |

Create a promotion for a promoter

```http
POST api/v1/promoters/{promoter_id}/promotions
```

| Parameter       | Type     | Description   |
| :-------------- | :------- | :------------ |
| `title`         | `string` | **Required**. |
| `description`   | `string` | **Required**. |

Get a promotion's details of a specific promoter

```http
GET api/v1/promoters/{promoter_id}/promotions/{promotion_id}
```

Get all promotions of a specific promoter

Necessary headers:

| Parameter               | Type     | Description   |
| :---------------------- | :------- | :------------ |
| `Authorization: Bearer` | `string` | **Required**. |

```http
GET api/v1/promoters/{promoter_id}/promotions/
```

Get details of a specific promoter

```http
GET api/v1/promoters/{promoter_id}
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
POST api/v1/tags/{tag_id}/promotion
```

| Parameter | Type      | Description   |
| :-------- | :-------- | :------------ |
| `id`      | `integer` | **Required**. |

Get specific tag

```http
GET api/v1/tags/{tag_id}
```

Get all tags

```http
GET api/v1/tags/
```
