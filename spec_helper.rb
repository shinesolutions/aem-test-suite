# Copyright 2018 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'capybara/rspec'
require 'fileutils'
require 'net/http'
require 'ruby_aem'
require 'yaml'
require 'capybara/poltergeist'
require 'phantomjs'
require 'tempfile'
require 'ruby_aem_aws'
Dir.glob("spec/**/*.rb").each do |req_files|
  require_relative req_files
end


RSpec.configure do |config|
  config.include(Features::StackManagerTestHelper)
  config.include(Features::SessionHelper)
end

def read_config
  YAML.load_file('conf.yaml')
end

def init_config
  @aem_conf = read_config['aem']
  @stack_prefix = @aem_conf['stack_prefix']
  aem_client = RubyAemAws::AemAws.new(conf = { aws_profile: 'sandpit'} )
  @aem_stack_manager_conn = aem_client.stack_manager(@stack_prefix)
  @aem_full_set = aem_client.full_set(@stack_prefix)
  aem_sm_conf = @aem_conf['stack-manager']
  @dynamodb_tablename = aem_sm_conf['dynamodb_tablename']
  @s3_bucket_name = aem_sm_conf['s3_bucket']
  @sns_topic = aem_sm_conf['sns_topic']
end

def init_stack_manager_config
  @conf_instance = @aem_conf["#{@instance.descriptor.ec2.component}"]
  #@aem_component = conf_instance['component']
  @user = @conf_instance['username']
  @password = @conf_instance['password']
  init_poltergeist_client(@conf_instance)
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
