### 0.9.5
*

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
