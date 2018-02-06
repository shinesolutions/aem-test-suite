require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['backuparn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'offline-snapshot'

		component = @conf_instance['component']
		@parameters = {:component       => "#{component}"
								 }
	end
	context 'Check if ssm command is successfull' do
		it 'should take a offline snapshot' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if snapshot was taken' do

		end
	end
end
