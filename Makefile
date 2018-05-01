version ?= 0.9.0

ci: deps lint

clean:
	rm -rf vendor *.lock

deps:
	gem install bundler
	rm -rf .bundle
	bundle install
	inspec vendor --overwrite
	cd vendor && find . -name "*.tar.gz" -exec tar -xzvf '{}' \;

package:
	rm -rf stage
	mkdir -p stage
	tar \
	    --exclude='.git*' \
	    --exclude='.tmp*' \
	    --exclude='stage*' \
	    --exclude='.idea*' \
	    --exclude='.DS_Store*' \
	    --exclude='logs*' \
	    --exclude='*.retry' \
	    --exclude='*.iml' \
			--exclude='./vendor*' \
	    -cvf \
	    stage/aem-stack-manager-messenger-$(version).tar ./
	gzip stage/aem-stack-manager-messenger-$(version).tar

lint:
	rubocop

acceptance:
	rspec acceptance/

define test_security
	cd vendor/inspec-aem-security-* && \
	  INSPEC_AEM_SECURITY_CONF=../../conf/aem.yaml make test-$(1)
endef

define aws
	cd vendor/inspec-aem-aws-* && \
	  INSPEC_AWS_CONF=../../conf/aws.yaml make test-$(1)
endef


test-security-author:
	$(call test_security,author)

test-security-publish:
	$(call test_security,publish)

test-security-publish-dispatcher:
	$(call test_security,publish-dispatcher)

test-aws-aem-readiness:
	$(call aws,ready)

test-aws-aem-recovery:
	$(call aws,recovery)

test-security: test-security-author test-security-publish test-security-publish-dispatcher

test-readiness: test-aws-aem-readiness

test-recovery: test-aws-aem-recovery

.PHONY: ci deps lint acceptance test-security-author test-security-publish test-security-publish-dispatcher test-security
