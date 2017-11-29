deps:
	gem install bundler
	rm -rf .bundle
	bundle install

acceptance:
	rspec acceptance/

.PHONY: deps acceptance
