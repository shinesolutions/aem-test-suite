require 'capybara/rspec'
require 'fileutils'
require 'net/http'
require 'ruby_aem'
require 'selenium/webdriver'
require 'yaml'

def read_config
  YAML.load_file('conf.yaml')
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
