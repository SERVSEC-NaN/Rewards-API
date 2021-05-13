<h1 align="center">Service Security Class</h1>

## Week 11: User Accounts.

- [ ] User accounts: let's create/update accounts for users Implement
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

- [ ] Use service objects to cleanup controllers and reuse functionality

Create service objects wherever you find you have to write chained
methods multiple lines to create or change resources Reuse your
service objects in controllers, tests, and code for seeding the
database.

- [ ] Implement a database seeding task (optional)

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

- [ ] Encrypt any sensitive columns that should not be read if your
database is stolen Discuss as a team which columns of which tables
contain the most sensitive data Create a SecureDB library class to
encrypt/decrypt sensitive methods.

- [ ] Create a database key for your development and test environments
only for now Encrypt!

Don't forget to put your config/secrets.yml file in .gitignore.

Change the name of encrypted columns (with a prefix/suffix like
secure_ or _secure) Create reader and writer methods in your models to
encrypt/decrypt columns on demand.

- [ ] Add Info/Warning/Error Logs Log warnings for mass assignment
attempts (display keys involved but do not log actual data!)  Log
errors for any unknown errors (typically 500 server errors) BONUS:
Notice that we cannot search through secured (encrypted) fields in our
database using Sequel. Consider creating a digest field for secured
fields that we can use for searching.

##  Week 9: Databases and ORM

### 1. Write migrations to create relational tables for your project:

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

### 2. Playing with Models!

### 3. Update your routes and test them!

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


##  Week 8: HTTP and Web APIs

### 1. Create a basic domain resource entity class

- [x] The #initialize method should create a new object

- [x] #new_id method to create unique IDs for new objects

- [x] #to_json method to represent a resource object as json

- [x] #save method to save a new entity

- [x] ::find method to find a specific entity by id or name

- [x] ::all method to return ids for all entities of this resource

- [x] Store and retrieve resources as json text files in an app/db/store
  folder with filenames that look like: “[id].txt”.

### 2. Create a Web API

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
