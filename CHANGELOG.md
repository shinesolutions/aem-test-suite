### 0.9.10
* Fix the make target test-contenthealthcheck-alarm-state to load correct configuration file #24

### 0.9.9
* Fix the make targets to load correct configuration file #24

### 0.9.8
* Upgrade inspec-aem-security to 0.10.1 to avoid aws-sdk dependency conflict

### 0.9.7
* Resolve InSpec profile dependencies as part of deps target

### 0.9.6
* Introduce bundle vendoring
* Sync all aem-test-suite InSpec libraries to use InSpec 1.51.6
* Upgrade inspec-aem-aws to 0.11.5, inspec-aem to 0.10.0, inspec-aem-security to 0.10.0

### 0.9.4
* Include vendor in published package
* Lock down InSpec dependency to 1.51.6 due to AWS SDK version dep in Chef tools
* Drop Ruby 2.1 and 2.2 support due to InSpec requirement

### 0.9.3
* Stack prefix is now a Make target argument instead of environment variable #20
* Add architecture suffix to all Make targets
* Set 'default' as the default AWS profile
* Add config_path Make target argument and config Make target

### 0.9.2
* Add Make target to check for content health check alarm state
* Fix inspec vendor path

### 0.9.1
* Add acceptance test support

### 0.9.0
* Initial version
