<h1 align="center">Service Security Class</h1>

[Web App](https://github.com/SERVSEC-NaN/Rewards-UI-Ruby#readme)

# Week 16: Authorization Protocols

1. AuthScopes: Use scoped authorization

 - Web API:

    - [ ] Create scoped authorization tokens

    - [ ] Create AuthScope library to process auth scopes

    - [ ] AuthToken should add scope to all tokens (default can be full access
      scope for user sessions)

    - [ ] Create route /account/[username] for account details with limited
      scope `auth_token`

    - [ ] Service Objects should extract `auth_scope` from `auth_token` and
      pass it to policy object

    - [ ] Policy Objects should interpret their policy rules within the given
      `auth_scope`

 - Web App:

 You might have to clear any existing session data that used old `auth_tokens`
 without scope Account information view should include a limited scope
 `auth_token` (e.g., read only for some resources)

# Week 15: Policies and Validation

3. Formal Policies

- Web API: Create policy objects in an app/policies folder

  - [ ] Create at least one policy object per resource (e.g., ProjectPolicy,
    DocumentPolicy, etc.)

  - [ ] Initialize policy objects with appropriate models (subject and object
    of policy)

  - [ ] Create true/false predicate methods check for key actions
    (creation/deletion/updating/viewing, etc.)

  - [ ] Make your predicate methods readable by using descriptive private
    predicates

  - [ ] Use your policy objects in resource request routes to check
    authorization of account and resource

- Web API: Create policy scope objects

  - [ ] Scope objects should return lists of all relevant objects for a given
    action (e.g., viewable) and agents (e.g., current_account)

  - [ ] Use your policy scopes to retrieve lists of objects to return on index
    routes (e.g., /api/v1/projects)

- Policy summaries

- [ ] Web API: Create a summary method for each policy object that returns a
  hash of all predicate names and results

- [ ] Web API: Routes that return a resource should return a jsonified summary
  of its policy for the given account

- Web App: Forms should determine authorization to show links/buttons/resources based on policy summaries returned by API

# Week 14: Token-based Registration and Authorization

- [ ] 1. Create a registration workflow that verifies user
      registration using token.

    Web App:

    - Please refer to
    [link](https://github.com/SERVSEC-NaN/Rewards-UI-Ruby#readme)
    for Web App details.

    Web API:

    - [ ] On registration, check if username/email available.
    - [ ] Use SendGrid API to send verification email with URL.
    - [ ] Create full account in database only when App confirms all
      details of account.

- [x] 2. Web API: Issue and require auth tokens.

    - [x] Create an AuthToken library:
      - Refactor SecureDB to extract a Securable module that handles
        all the crypto logic.
      - Both SecureDB and AuthToken should extend Securable.

    - [x] Send back an auth token along with account information
          whenever an account is authenticated.

    - [x] Whenever a route requires accessing an account's resources,
          check the auth token.
      - Create helper methods that verify account identity of token
        with resource owner.
      - Check token in `HTTP_AUTHENTICATION` header of `HTTP` request
        has `Bearer <TOKEN>`.

    - [x] Return `403` for any suspicious cases: token is expired,
          resource does not belong to account.

- [x] 3. Web App: Store and use auth tokens.

    > Please refer to
    > [link](https://github.com/SERVSEC-NaN/Rewards-UI-Ruby#readme) for
    > Web App details.

- [ ] 4. API+App: Add features in App to view index of resources.
  - Users can see list of all resources they own.

  - See if you can avoid putting username in API URL – if possible,
  use the username in `auth_token` to find relevant resources.


# Week 13: Secure Sessions

- [ ] 1. App: Strengthening our Web Application (optional) Use WebMock to
write basic tests for your Web Application’s services Use the
rack-ssl-enforcer gem to redirect users to HTTPS connections in
production only

- [x] 2. Deploy your API and App to Heroku API: setup and integrate PostGres
database App: Ensure that it is talking to the deployed API

> Web API available at: https://reward-api-ruby.herokuapp.com. Please
> see <a href="api.md">API documentation</a> for details.

> Please refer to
> [link](https://github.com/SERVSEC-NaN/Rewards-UI-Ruby#readme) for
> Web App details.

- [x] 3. App: Encrypt session data Create a secure messaging library
that can encrypt and decrypt messages Use a secret key stored in
environment variable MSG_KEY Use NaCl’s SimpleBox for all cryptography
Create a secure session library to securely set and get session
variables Use the secure messaging library from above for all crypto

- [x] 4. App: Switch our session storage to distributed pool Provision a
Redis machine on Heroku Specify Redis as our application's session
store

> Please refer to
> [link](https://github.com/SERVSEC-NaN/Rewards-UI-Ruby#readme) for Web
> App details.

- [ ] 5. Create a very basic (and risky!) registration workflow between App
 and API API: Create a POST route to create accounts given email,
 username, and password App: Allow users to register accounts Accept
 posts from a registration form with email, username, and password Use
 a service object to post the data to your API Notice: We have not
 performed any verification of account details

> Since we only have created an admin account we do not implement
> registration feature. Instead, the database is seeded with
> credentials for admin account that can be logged in with through the
> Web App.

# Week 12: Authentication and Sessions

- [x] 1. Updating our Web API Structure (optional) Split your controller
into multiple files Use the multi_route plugin for Roda to dispatch
requests to the right routing block

- [x] 2. Add POST route to Web API to authenticate credentials e.g., POST
'/api/v1/auth/authentication' If username/password is correct, return
JSONified user information Otherwise, return a 403 error code with a
json message body.

- [x] 3. Require SSL connections to Web API Check protocol schema for
incoming requests Block non-secure requests for production (HTTP)


# Week 11: User Accounts.

- [x] User accounts: let's create/update accounts for users Implement
salted, hashed (with key-stretching) passwords.

Create a KeyStretching module Create a Password model Write
appropriate unit tests for your handling passwords Create a migration
and model (call it Account) for user accounts Make sure your
migrations add a hashed password field Give your Account model methods
to set and check (not get!) passwords.

- [x] Many-to-Many Associations

Add any many-to-many relationships you need using join tables Affected
models should define many-to-many relationships in in both directions
Name your relationships appropriately in each direction (e.g.,
collaborators vs. collaborations) Use association_dependencies to
maintain table integrity (use destroy or nullify to specify how to
cascade resource destruction).

- [x] Use service objects to cleanup controllers and reuse functionality

Create service objects wherever you find you have to write chained
methods multiple lines to create or change resources Reuse your
service objects in controllers, tests, and code for seeding the
database.

- [x] Implement a database seeding task (optional)

Use the sequel-seed gem to create a `rake db:seed` task for your API Put
your seeding code in `seeds/<date>_<description>.rb` files (example,
20180503_create_all.rb) Ensure your code is run in a run method in a
Sequel.seed(:development) call Make sure that anyone who wants to
collaborate with your team can get setup by simply using:

```sh
bundle install
rake db:migrate
rake db:seed
```
Integrate accounts into your API routes:
Write a controller route (and tests) to create an account
Write a controller route (and tests) to get an account

## Week 10: Database Hardening

- [x] Prevent mass assignment vulnerabilities by restricting columns

Add a whitelist of permissible methods to restrict which attributes of
your models can be changed by a mass assignment from user input Add
tests to ensure that mass assignment does not work (returns 400 Bad
Request).

- [x] Prevent Basic SQL injection attacks Use string literalization
and/or query parameterization Add tests that validate that SQL
injection does not work on routes with sensitive data.

- [x] UUIDs (optional) Discuss as a team if there are any primary keys
that you are not comfortable displaying on route URL Modify the
migrations and models for those tables to use UUIDs instead Use a uuid
type in your migrations Use the :uuid plugin in Sequel models to
autogenerate UUIDs.

- [x] Encrypt any sensitive columns that should not be read if your
database is stolen Discuss as a team which columns of which tables
contain the most sensitive data Create a SecureDB library class to
encrypt/decrypt sensitive methods.

- [x] Create a database key for your development and test environments
only for now Encrypt!

Don't forget to put your config/secrets.yml file in .gitignore.

Change the name of encrypted columns (with a prefix/suffix like
secure_ or _secure) Create reader and writer methods in your models to
encrypt/decrypt columns on demand.

- [x] Add Info/Warning/Error Logs Log warnings for mass assignment
attempts (display keys involved but do not log actual data!)  Log
errors for any unknown errors (typically 500 server errors) BONUS:
Notice that we cannot search through secured (encrypted) fields in our
database using Sequel. Consider creating a digest field for secured
fields that we can use for searching.

##  Week 9: Databases and ORM

 1. Write migrations to create relational tables for your project:

- [x] Identify two model entities you need for your project, define
  corresponding database tables.

- [x] Add gems to Gemfile and create config/environments.rb.

- [x] Create migration files in app/db/migrations/ that define how to
  create your tables.

- [x] Create a Rakefile with a db:migrate and other database related
  tasks.

- [x] Run migrations to create development.db and test.db Sqlite databases
  for the two environments.

- [x] Follow the plural/singular conventions of database tables and
  foreign keys.

2. Playing with Models!

3. Update your routes and test them!

- [x] Test the root route of your Web API to make sure it returns a valid
  message.

- Test each GET and POST route you create:

    - [x] Add a before block to your tests that deletes your tables before
      each test!

    - [x] Write a HAPPY path that tests a successful case for each
      route.

    - [x] Write at least one SAD path that tests a fail case for each
      route.

    - [x] Be able to GET a list of all resource of that type.

    - [x] Be able to GET a single resource of that type.

    - [x] Be able to POST to create a single resource of that type.


#  Week 8: HTTP and Web APIs

 1. Create a basic domain resource entity class

- [x] The #initialize method should create a new object

- [x] #new_id method to create unique IDs for new objects

- [x] #to_json method to represent a resource object as json

- [x] #save method to save a new entity

- [x] ::find method to find a specific entity by id or name

- [x] ::all method to return ids for all entities of this resource

- [x] Store and retrieve resources as json text files in an app/db/store
  folder with filenames that look like: “[id].txt”.

 2. Create a Web API

- [x] Create an appropriately named Roda-based API class in
  `app/controllers/app.rb`.

- [x] Create a root route (/) that returns a basic json message.

- [x] Create one POST route to create a new resource, given json
  information about it.

- [x] create one GET route to return details of a specific resource.

- [x] create one GET route to return an ID list of all resources.

- [x] Create a helpful README.md with instructions on how to use your API,
  including all routes.

- [x] Create a LICENSE file with terms of how your code can be adapted by
  others.
