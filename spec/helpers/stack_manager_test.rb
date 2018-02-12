module Features
  module StackManagerTestHelper
    def execute(task, parameters)
      stack_prefix = @aem_conf['stack_prefix']
      topic_arn = @sm_conf['topicarn']
      dyndb_table_name = @sm_conf['dyndb_table_name']
      # Should be at least the same, like timeout of cmd execution
      retry_opts = { max_tries: 5,
                     base_sleep_seconds: 5.0,
                     max_sleep_seconds: 15.5 }
      ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix, dyndb_table_name)
      ssm_command.check(task, parameters, retry_opts)
    end

    def visit_page(url)
      visit url
      page.status_code
    end

    def sign_in
      visit 'libs/granite/core/content/login.html'
      fill_in 'username', with: @user
      fill_in 'password', with: @password
      click_button 'submit-button'
    end

    def sign_out
      visit '/system/sling/logout.html'
    end
  end
end
