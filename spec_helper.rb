require 'capybara/rspec'
require 'fileutils'
require 'net/http'
require 'ruby_aem'
require 'yaml'
require 'capybara/poltergeist'
require 'phantomjs'
require 'tempfile'
require 'ruby_aem_aws'
require_relative 'spec/helpers/stack_manager_test_helper'
require_relative 'spec/helpers/session_helper'
# require_relative '../ruby_aem_aws/lib/ruby_aem_aws'

RSpec.configure do |config|
  config.include(Features::StackManagerTestHelper)
  config.include(Features::SessionHelper)
end

def read_config
  YAML.load_file('conf.yaml')
end

def init_stack_manager_config
  aem_conf = read_config['aem']
  conf_instance = aem_conf['author-primary']
  @stack_prefix = aem_conf['stack_prefix']
  @aem_sm_conf = aem_conf['stack-manager']
  @s3_bucket_name = aem_conf['s3_bucket']
  @aem_component = conf_instance['component']
  @user = conf_instance['username']
  @password = conf_instance['password']
  init_poltergeist_client(conf_instance)
end

def init_poltergeist_client(conf)
  Capybara.register_driver :poltergeist_debug do |app|
    Capybara::Poltergeist::Driver.new(app, debug: false, js_errors: false)
  end
  Capybara.current_driver = :poltergeist_debug
  Capybara.configure do |config|
    config.default_max_wait_time = 15
    config.ignore_hidden_elements = false
    config.app_host = "#{conf['protocol']}://#{conf['host']}:#{conf['port']}"
  end
end

def init_author_client(conf)
  RubyAem::Aem.new(
    username: conf['username'] || 'admin',
    password: conf['password'] || 'admin',
    protocol: conf['protocol'] || 'http',
    host: conf['host'] || 'localhost',
    port: conf['port'] ? conf['port'].to_i : 4502,
    debug: conf['debug'] ? conf['debug'] == true : false
  )
end

def init_publish_client(conf)
  RubyAem::Aem.new(
    username: conf['username'] || 'admin',
    password: conf['password'] || 'admin',
    protocol: conf['protocol'] || 'http',
    host: conf['host'] || 'localhost',
    port: conf['port'] ? conf['port'].to_i : 4503,
    debug: conf['debug'] ? conf['debug'] == true : false
  )
end

def init_dispatcher_client(conf)
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, js_errors: false)
  end
  Capybara.current_driver = :poltergeist
  Capybara.app_host = "#{conf['protocol']}://#{conf['host']}:#{conf['port']}"
end

def retry_opts
  {
    _retries: {
      max_tries: 120,
      base_sleep_seconds: 10,
      max_sleep_seconds: 10
    }
  }
end

def result_handler(results)
end
