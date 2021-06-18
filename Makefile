-include .env

.PHONY: setup
setup:
	@mkdir -p ./app/db/store ||:
	@bundle install
	@bundle exec rake db:migrate

.PHONY: test
test:
	@env RACK_ENV=test bundle exec rake db:migrate
	@bundle exec rake spec

.PHONY: up
up:
	@bundle exec rake run:dev
