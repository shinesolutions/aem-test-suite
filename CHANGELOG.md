# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 0.9.12 - 2019-05-22
### Changed
- Upgrade inspec-aem-aws to 0.14.1
- Upgrade inspec-aem-security to 0.10.2
- Lock down dependencies version

## 0.9.11 - 2019-04-23
### Changed
- Update Changelog style to [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- Upgrade inspec-aem-aws to 0.14.0

## 0.9.10 - 2018-12-03
### Fixed
- Fix the make target test-contenthealthcheck-alarm-state to load correct configuration file [#24]

## 0.9.9 - 2018-11-28
### Fixed
- Fix the make targets to load correct configuration file [#24]

## 0.9.8 - 2018-10-10
### Changed
- Upgrade inspec-aem-security to 0.10.1 to avoid aws-sdk dependency conflict

## 0.9.7 - 2018-10-10
### Fixed
- Resolve InSpec profile dependencies as part of deps target

## 0.9.6 - 2018-10-10
### Added
- Introduce bundle vendoring

### Changed
- Sync all aem-test-suite InSpec libraries to use InSpec 1.51.6
- Upgrade inspec-aem-aws to 0.11.5
- Upgrade inspec-aem to 0.10.0
- Upgrade inspec-aem-security to 0.10.0

## 0.9.4 - 2018-10-09
### Added
- Include vendor in published package

### Changed
- Lock down InSpec dependency to 1.51.6 due to AWS SDK version dep in Chef tools

### Removed
- Drop Ruby 2.1 and 2.2 support due to InSpec requirement

## 0.9.3 - 2018-07-12
### Added
- Add architecture suffix to all Make targets
- Add config_path Make target argument and config Make target

### Changed
- Stack prefix is now a Make target argument instead of environment variable [#20]
- Set 'default' as the default AWS profile

## 0.9.2 - 2018-06-04
### Added
- Add Make target to check for content health check alarm state

### Changed
- Upgrade inspec-aem-aws to 0.11.1

### Fixed
- Fix inspec vendor path

## 0.9.1 - 2018-03-31
### Added
- Add acceptance test support

## 0.9.0 - 2018-03-31
### Added
- Initial version
