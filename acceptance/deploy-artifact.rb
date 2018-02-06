require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		conf = read_config['aem']
		stack_prefix = conf['stack_prefix']
		topic_arn = conf['topicarn']

		@conf_instance = conf['author-primary']

		@ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
		@task = 'deploy-artifact'

		component = @conf_instance['component']
		source = 'source'
		group = 'group'
		name = 'name'
		version = 'version'
		replicate = 'replicate'
		activate = 'activate'
		force = 'force'
		@parameters = {:component => "#{component}",
								   :source    => "#{source}",
								   :group     => "#{group}",
									 :name      => "#{name}",
									 :version   => "#{version}",
									 :replicate => "#{replicate}",
									 :activate  => "#{activate}",
									 :force     => "#{force}",
							    }
	end

	context 'Check if ssm command is successfull' do
		it 'should deploy artifact' do
			 @ssm_command.check(@task, @parameters)
		end

		it 'should check if artifact is deployed' do

		end
	end
end
