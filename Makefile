version ?= 0.9.10

ci: clean deps lint package

clean:
	rm -rf bin/ vendor

deps:
	gem install bundler
	rm -rf .bundle
	bundle install --binstubs
	bundle exec inspec vendor --overwrite
	cd vendor && find . -name "*.tar.gz" -exec tar -xzvf '{}' \; -exec rm '{}' \;
	cd vendor && mv inspec-aem-aws-*.*.* inspec-aem-aws && cd inspec-aem-aws && make deps
	cd vendor && mv inspec-aem-security-*.*.* inspec-aem-security && cd inspec-aem-security && make deps

package:
	rm -rf stage
	mkdir -p stage
	tar \
	    --exclude='.git*' \
			--exclude='.bundle*' \
			--exclude='bin*' \
			--exclude='vendor*' \
	    --exclude='.tmp*' \
	    --exclude='stage*' \
	    --exclude='.idea*' \
	    --exclude='.DS_Store*' \
	    --exclude='logs*' \
	    --exclude='*.retry' \
	    --exclude='*.iml' \
	    -cvf \
	    stage/aem-test-suite-$(version).tar ./
	gzip stage/aem-test-suite-$(version).tar

lint:
	bundle exec rubocop Gemfile

# copy user config to InSpec profiles config
config-aem-aws:
	cp $(config_path)/aem-aws.yaml vendor/inspec-aem-aws/conf/aem-aws.yaml
config-aem:
	cp $(config_path)/aem.yaml vendor/inspec-aem-security/conf/aem.yaml

acceptance:
	rspec acceptance/

define test_security
	cd vendor/inspec-aem-security && \
	  INSPEC_AEM_SECURITY_CONF=conf/aem.yaml \
		aem_stack_prefix=$(2) \
		make test-$(1)
endef

define aem_aws
	cd vendor/inspec-aem-aws && \
	  INSPEC_AEM_AWS_CONF=conf/aem-aws.yaml \
		aem_stack_prefix=$(2) \
		make test-$(1)
endef

define test-acceptance
	cd vendor/inspec-aem-aws && \
	  INSPEC_AEM_AWS_CONF=conf/aem-aws.yaml \
		aem_stack_prefix=$(2) \
		make test-acceptance-$(1)
endef

define test-contenthealthcheck-state
	cd vendor/inspec-aem-aws && \
	  INSPEC_AEM_AWS_CONF=conf/aem-aws.yaml \
		aem_stack_prefix=$(1) \
		make test-contenthealthcheck-alarm-state
endef

test-security-author:
	$(call test_security,author,$(stack_prefix))

test-security-publish:
	$(call test_security,publish,$(stack_prefix))

test-security-publish-dispatcher:
	$(call test_security,publish-dispatcher,$(stack_prefix))

test-aem-aws-readiness-full-set:
	$(call aem_aws,readiness,$(stack_prefix))

test-aem-aws-recovery-full-set:
	$(call aem_aws,recovery,$(stack_prefix))

test-acceptance-architecture-full-set:
	$(call test-acceptance,full-set,$(stack_prefix))

test-acceptance-author-primary:
	$(call test-acceptance,author-primary,$(stack_prefix))

test-acceptance-author-standby:
	$(call test-acceptance,author-standby,$(stack_prefix))

test-acceptance-publish:
	$(call test-acceptance,publish,$(stack_prefix))

test-acceptance-author-dispatcher:
	$(call test-acceptance,author-dispatcher,$(stack_prefix))

test-acceptance-publish-dispatcher:
	$(call test-acceptance,publish-dispatcher,$(stack_prefix))

test-acceptance-orchestrator:
	$(call test-acceptance,orchestrator,$(stack_prefix))

test-contenthealthcheck-alarm:
	$(call test-contenthealthcheck-state,$(stack_prefix))

test-security: config-aem test-security-author test-security-publish test-security-publish-dispatcher

test-readiness-full-set: config-aem-aws test-aem-aws-readiness-full-set

test-recovery-full-set: config-aem-aws test-aem-aws-recovery-full-set

test-acceptance-full-set: config-aem-aws test-acceptance-architecture-full-set test-acceptance-author-primary test-acceptance-author-standby test-acceptance-publish test-acceptance-author-dispatcher test-acceptance-publish-dispatcher test-acceptance-orchestrator

test-contenthealthcheck-alarm-state: config-aem-aws test-contenthealthcheck-alarm

.PHONY: ci deps lint acceptance test-security-author test-security-publish test-security-publish-dispatcher test-security
