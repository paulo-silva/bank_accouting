# BankAccounting
[![CircleCI](https://circleci.com/gh/paulo-silva/bank_accouting.svg?style=svg&circle-token=16ac96ce5b8014a8ea22d67d7d5a9fcc2661fd02)](https://circleci.com/gh/paulo-silva/bank_accouting)

BankAccounting is an API application that manages banking accounts, allowing to make transfers between them and checking its balance.

## Getting Started

BankAccounting was developed using Phoenix framework (`v.1.4.11`) and PostgreSQL (`11.5`) as database.

### Executing via Docker

To start using BankAccounting you can simply use docker-compose:

```shell
$ docker-compose up
```

The command above will set up a PostgreSQL image, will install the project dependencies and will start the Phoenix server.

### Manual Installation

If you prefer, you can setup BankAccouting manually, following the steps below:

1. Install Elixir `~> 1.9.4` (you can use a version manager like [asdf](<https://asdf-vm.com/#/core-manage-asdf-vm>) for it);
2. Install PostgreSQL `~> 11`;
3. Install dependencies with `mix deps.get`;
4. Create database and run its migrations with `mix ecto.setup`;
5. Start Phoenix endpoint with `mix phx.server`;


After Phoenix server start, you can access BankAccounting by `localhost:4000` via an API client, like Postman for example.

## Features

Most of BankAccounting features are protected by an authentication layer, so the first step is to know how we create a user in our application and use it to access other features. Check it below:

<details>
  <summary><b>Creating a new User</b></summary>

  #### Endpoint
  `POST /api/users`

  #### Request Body
  ```json
  {
      "user": { "email": "tony.stark@avengers.com", "password": "love-you-3-thousand" }
  }
  ```

  #### Response
  `201 CREATED`

  ```json
  {
      "user": { "id": 1, "email": "tony.stark@avengers.com" }
  }
  ```
</details>


Great! Now we have a user that we can use to access other API routes, but first, we need to generate an authentication token that will be provided in `Authorization` request header. You can make it using the request below:

<details>
  <summary><b>Generating authorization token</b></summary>

  #### Endpoint
  `POST /api/auth/sign_in`

  #### Request Body
  ```json
  { "email": "tony.stark@avengers.com", "password": "love-you-3-thousand" }
  ```

  #### Response
  `200 OK`

  ```json
  {
      "data": {
          "token": "<TOKEN>"
      }
  }
  ```
</details>

For some reason, like a security issue, you may want to exclude the authorization token, to do it, you can use the following endpoint:

<details>
  <summary><b>Excluding authorization token</b></summary>

  #### Endpoint
  `DELETE /api/auth/sign_out`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Response
  `204 No Content`
</details>


## Request that requires an authorization token

<details>
  <summary><b>Creating Banking Account</b></summary>

  #### Endpoint
  `POST /api/accounts`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Request Body
  ```json
  {
      "account": { "amount": 100 }
  }
  ```

  #### Response
  ```json
  {
      "account": { "id": 1, "amount": "R$ 100,00" }
  }
  ```
</details>

<details>
  <summary><b>Listing Banking Accounts</b></summary>

  #### Endpoint
  `GET /api/accounts`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Response
  ```json
  {
      "accounts": [
          { "id": 1, "amount": "R$ 100,00" },
          { "id": 2, "amount": "R$ 500,00" },
          { "id": 2, "amount": "R$ 120,00" }
      ]
  }
  ```
</details>

<details>
  <summary><b>Showing Banking Account</b></summary>

  #### Endpoint
  `GET /api/accounts/:id`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Response
  ```json
  {
      "account": { "id": 1, "amount": "R$ 100,00" }
  }
  ```
</details>

<details>
  <summary><b>Updating Banking Accounts</b></summary>

  #### Endpoint
  `PUT /api/accounts/:id`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  ### Request Body
  ```json
  {
    "account": { "amount": 125 }
  }
  ```

  #### Response
  ```json
  {
    "account": { "id": 1, "amount": "R$ 125,00" }
  }
  ```
</details>

<details>
  <summary><b>Removing Banking Account</b></summary>

  #### Endpoint
  `DELETE /api/accounts/:id`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Response
  `204 NO CONTENT`
</details>

<details>
  <summary><b>Consulting Account Balance</b></summary>

  #### Endpoint
  `GET /api/accounts/:id/balance`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Response
  `200 OK`

  ```json
  {
    "account_id": 1,
    "amount": "R$ 20,00",
    "transfers": [
      { "id": 1, "amount": "R$ 50,00", "origin_account_id": 1, "destiny_account_id": 2 },
      { "id": 1, "amount": "R$ 50,00", "origin_account_id": 1, "destiny_account_id": 2 },
      { "id": 1, "amount": "R$ 20,00", "origin_account_id": 2, "destiny_account_id": 1 }
    ]
  }
  ```
</details>

<details>
  <summary><b>Making transfers between accounts</b></summary>

  #### Endpoint
  `POST /api/transfers`

  #### Request Header
  `Authorization: Bearer <TOKEN>`

  #### Request Body
  ```json
  {
    "source_account_id": 1, "destiny_account_id": 2, "amount": "29.90"
  }
  ```

  #### Response
  `201 CREATED`

  ```json
  { "status": "transferred" }
  ```
</details>

## Contributing

If you're considering to contribute with this project than Thank you :heart:! We have a guide below that can help you
start to contribute with the project:

First, you can contribute in many ways! For example:

- Add/Update documentation and "how-to" to README.
- Improve the existing feature examples.
- Hack on BankAccouting itself by fixing/reporting bugs you've found or adding new features to BankAccounting.

When contributing to BankAccounting, we ask that you:

- Provide information about what you plan to do in the GitHub Issue Tracker so we can provide feedback.
- Provide tests and documentation whenever possible. It is very unlikely that we will accept new features into BankAccounting
without the proper testing and documentation.
- Open a GitHub Pull Request and we will review your contribution and respond as quicly as possible.

### Running testing

You can run the entire suite test with the following command:

```bash
$ mix test
```

To run a single test, provide the filename:

```bash
$ mix test test/bank_accounting_web/controllers/user_controller_test.exs
```
