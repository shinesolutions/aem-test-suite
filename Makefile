ci: deps lint

deps:
	gem install bundler
	rm -rf .bundle
	bundle install

lint:
	rubocop

acceptance:
	rspec acceptance/

security:
	rspec security/

.PHONY: ci deps lint acceptance security
