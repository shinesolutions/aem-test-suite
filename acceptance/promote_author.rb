require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['topicarn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'promote-author'

		component = @conf_instance['component']
		@parameters = {:component       => "#{component}"
								 }
	end
	context 'Check if ssm command is successfull' do
		it 'should promote the author' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if author is promoted' do

		end
	end
end
