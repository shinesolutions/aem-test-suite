deps:
	gem install bundler
	rm -rf .bundle
	bundle install
	gem install rspec

acceptance:
	rspec acceptance/

.PHONY: deps acceptance
