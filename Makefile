ci: deps lint

clean:
	rm -rf vendor *.lock

deps:
	gem install bundler
	rm -rf .bundle
	bundle install
	inspec vendor --overwrite
	cd vendor && gunzip *.tar.gz && tar -xvf *.tar

lint:
	rubocop

acceptance:
	rspec acceptance/

define test_security
	cd vendor/inspec-aem-security-* && \
	  INSPEC_AEM_SECURITY_CONF=../../conf/aem.yaml make test-$(1)
endef

test-security-author:
	$(call test_security,author)

test-security-publish:
	$(call test_security,publish)

test-security-publish-dispatcher:
	$(call test_security,publish-dispatcher)

test-security: test-security-author test-security-publish test-security-publish-dispatcher

.PHONY: ci deps lint acceptance test-security-author test-security-publish test-security-publish-dispatcher test-security
