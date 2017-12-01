deps:
	gem install bundler
	rm -rf .bundle
	bundle install

lint:
	rubocop

acceptance:
	rspec acceptance/

.PHONY: deps acceptance
