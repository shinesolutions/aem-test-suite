require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['topicarn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'enable-crxde'

		component = @conf_instance['component']
		@parameters = {:component => "#{component}"}
	end

	before :each do
		init_poltergeist_client(@conf_instance)
		page.driver.basic_authorize(@conf_instance['username'], @conf_instance['password'])
	end

	context 'Check if ssm command is successfull' do
		it 'should enable crxde' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if crxde is enabled' do
			visit '/crx/server/crx.default/jcr:root/.1.json'
			expect(page.status_code).to eq(200)
		end
	end
end
