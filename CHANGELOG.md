# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 2.7.0 - 2022-08-16
### Changed
- Upgraded inspec-aem-security to 1.3.0

## 2.6.0 - 2022-02-04
### Changed
- Upgraded inspec-aem-aws to 2.4.0

## 2.5.0 - 2021-12-13
### Changed
- Upgraded inspec-aem-security to 1.2.0

## 2.4.0 - 2021-12-02
### Changed
- Upgraded inspec-aem-aws to 2.3.0
- Upgraded ruby_aem_aws to 2.2.1

## 2.3.0 - 2021-11-22
### Changed
- Upgraded inspec-aem-aws to 2.2.0
- Upgraded ruby_aem_aws to 2.2.0

## 2.2.1 - 2021-11-19
### Fixed
- Fix incompatible ruby_aem_aws version for inspec-aem-aws 2.1.0

## 2.2.0 - 2021-11-19
### Changed
- Upgraded inspec-aem-aws to 2.1.0

## 2.1.0 - 2021-10-06
### Added
- Add release-major, release-minor, release-patch, and publish Makefile targets and GitHub Actions

### Changed
- Upgraded inspec-aem-security to 1.1.1
- Upgraded inspec-aem-aws to 2.0.2
- Upgraded ruby-aem-aws to 2.0.1
- Upgraded ruby-aem to 3.13.1

## 2.0.0 - 2020-11-30
### Changed
- Upgraded inspec-aem-aws to 2.0.0
- Upgraded ruby-aem-aws to 2.0.0

## 1.15.0 - 2020-03-01
### Changed
- Update inspec-aem-aws configuration to increase readiness test retry to 6h
- Update inspec-aem-aws configuration to increase recovery test retry to 6h
- Upgraded inspec-aem-aws to 1.10.0
- Upgraded ruby-aem-aws to 1.5.0

## 1.14.0 - 2020-02-17
### Changed
- Upgraded inspec-aem-aws to 1.9.0
- Upgraded inspec-aem-security to 1.1.0

## 1.13.0 - 2020-01-19
### Changed
- Replace Maven Central domain http://central.maven.org with https://repo.maven.apache.org

## 1.12.0 - 2020-01-14
### Changed
- Upgrade inspec-aem-aws to 1.8.0

## 1.11.0 - 2020-01-14
### Changed
- Upgrade inspec-aem-aws to 1.7.0

## 1.10.0 - 2020-01-13
### Added
- Add new make target `config` to replace deprecated make targets `config-aem-aws` & `config-aem`#35

### Removed
- Make targets `config-aem-aws` & `config-aem` are now deprecated [#35]

## 1.9.0 - 2019-12-12
### Changed
- Reset last gem updates in order to maintain consistency with sub-deps

## 1.8.0 - 2019-12-10
### Changed
- Update library dependencies in order to fix deps resolve slowness

## 1.7.0 - 2019-11-26
### Changed
- Upgrade inspec-aem-aws to 1.5.0

## 1.6.0 - 2019-09-07
### Changed
- Upgrade inspec-aem-aws to 1.4.0

## 1.5.0 - 2019-08-27
### Changed
- Upgrade inspec-aem-security to 1.0.0

## 1.4.0 - 2019-08-15
### Changed
- Upgrade inspec-aem-aws to 1.3.0

## 1.3.0 - 2019-07-24
### Added
- Add new make target to check FS stacks with disabled chaos monkey shinesolutions/aem-aws-stack-builder#290
- Add support to run recovery test with disabled chaos monkey [#32]

## 1.2.0 - 2019-05-23
### Added
- Add Make target for testing provisioning state
- Add Make target for testing provisioning state & full-set readiness
- Add Make target for testing readiness on consolidated

## 1.1.0 - 2019-05-23
### Added
- Add readiness check for consolidated

### Changed
- Drop ruby 2.3 support
- Upgrade inspec-aem-aws to 1.0.0
- Readiness check now utilises ComponentInitStatus tag

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
