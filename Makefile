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
	    stage/aem-test-suite-$(version).tar ./
	gzip stage/aem-test-suite-$(version).tar

lint:
	rubocop

acceptance:
	rspec acceptance/

define test_security
	cd vendor/inspec-aem-security-* && \
	  INSPEC_AEM_SECURITY_CONF=../../conf/aem.yaml make test-$(1)
endef

define aem_aws
	cd vendor/inspec-aem-aws-* && \
	  INSPEC_AEM_AWS_CONF=../../conf/aem-aws.yaml make test-$(1)
endef

define test-acceptance
	cd vendor/inspec-aem-aws-* && \
	  INSPEC_AEM_AWS_CONF=../../conf/aem-aws.yaml make test-acceptance-$(1)
endef


test-security-author:
	$(call test_security,author)

test-security-publish:
	$(call test_security,publish)

test-security-publish-dispatcher:
	$(call test_security,publish-dispatcher)

test-aem-aws-readiness:
	$(call aem_aws,readiness)

test-aem-aws-recovery:
	$(call aem_aws,recovery)

test-acceptance-stack:
	$(call test-acceptance,full-set)

test-acceptance-author-primary:
	$(call test-acceptance,author-primary)

test-acceptance-author-standby:
	$(call test-acceptance,author-standby)

test-acceptance-publish:
	$(call test-acceptance,publish)

test-acceptance-author-dispatcher:
	$(call test-acceptance,author-dispatcher)

test-acceptance-publish-dispatcher:
	$(call test-acceptance,publish-dispatcher)

test-acceptance-orchestrator:
	$(call test-acceptance,orchestrator)

test-security: test-security-author test-security-publish test-security-publish-dispatcher

test-readiness: test-aem-aws-readiness

test-recovery: test-aem-aws-recovery

test-acceptance-full-set: test-acceptance-stack test-acceptance-author-primary test-acceptance-author-standby test-acceptance-publish test-acceptance-author-dispatcher test-acceptance-publish-dispatcher test-acceptance-orchestrator

.PHONY: ci deps lint acceptance test-security-author test-security-publish test-security-publish-dispatcher test-security
