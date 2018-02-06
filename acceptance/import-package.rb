require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['topicarn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'export-package'

		component = @conf_instance['component']
		@parameters = {:component            => "#{component}",
				 					 :source_stack_prefix  => "source_stack_prefix",
		               :package_group        => "package_group",
								   :package_name         => "package_name",
									 :package_datestamp    => "package_datestamp",
								 }
	end
	context 'Check if ssm command is successfull' do
		it 'should import a package' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if packages are exported' do

		end
	end
end
