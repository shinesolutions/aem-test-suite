require 'capybara/rspec'
require 'fileutils'
require 'net/http'
require 'ruby_aem'
require 'selenium/webdriver'
require 'yaml'

def read_config
  YAML.load_file('test/acceptance/conf.yaml')
end

def init_author_client
  RubyAem::Aem.new(
    username: ENV['aem_author_username'] || 'admin',
    password: ENV['aem_author_password'] || 'admin',
    protocol: ENV['aem_author_protocol'] || 'http',
    host: ENV['aem_author_host'] || 'localhost',
    port: ENV['aem_author_port'] ? ENV['aem_author_port'].to_i : 4502,
    debug: ENV['aem_author_debug'] ? ENV['aem_author_debug'] == 'true' : false
  )
end

def init_publish_client
  RubyAem::Aem.new(
    username: ENV['aem_publish_username'] || 'admin',
    password: ENV['aem_publish_password'] || 'admin',
    protocol: ENV['aem_publish_protocol'] || 'http',
    host: ENV['aem_publish_host'] || 'localhost',
    port: ENV['aem_publish_port'] ? ENV['aem_publish_port'].to_i : 4503,
    debug: ENV['aem_publish_debug'] ? ENV['aem_publish_debug'] == 'true' : false
  )
end

def init_dispatcher_client
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end

  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
    )

    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      desired_capabilities: capabilities
  end

  Capybara.current_driver = :headless_chrome
  Capybara.app_host = 'http://www.google.com'
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
