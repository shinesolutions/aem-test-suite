require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['topicarn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'deploy-artifacts'

		component = @conf_instance['component']
		descriptor_file = 'deploy_artifacts.json'
		@parameters = {:component       => "#{component}",
		               :descriptor_file => "#{descriptor_file}"
								 }
	end

	context 'Check if ssm command is successfull' do
		it 'should deploy artifacts' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if artifact is deployed' do

		end
	end
end
