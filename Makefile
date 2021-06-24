.PHONY: help
help:
	@printf "%s\n" "Useful targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  make %-15s\033[0m %s\n", $$1, $$2}'


.PHONY: clean
clean:
	@rm -fr ./app/db/store ||:

.PHONY: setup
setup: clean ## Download gems, reset and re-migrate the database.
	@mkdir -p ./app/db/store
	@bundle config set --local without 'production'
	@bundle install
	@bundle exec rake db:migrate

.PHONY: up
up:     ## Run the development server
	@bundle exec rake run:dev

.PHONY: enter
enter:  ## Enter the development REPL console
	@bundle exec rake console

.PHONY: test
test:   ## Run all tests. Append (TEST=file.rb) to run specific one.
	@env RACK_ENV=test bundle exec rake db:migrate
	@bundle exec rake spec $(ARGS)
