-include .env

.PHONY: clean
clean:
	@rm -fr ./app/db/store ||:

.PHONY: setup
setup: clean
	@mkdir -p ./app/db/store
	@bundle install
	@bundle exec rake db:migrate

.PHONY: enter
enter:
	@bundle exec rake console

.PHONY: test
test:
	@env RACK_ENV=test bundle exec rake db:migrate
	@bundle exec rake spec

.PHONY: up
up:
	@bundle exec rake run:dev
