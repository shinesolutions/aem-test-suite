require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
  before :all do
    conf = read_config['aem']
    stack_prefix = conf['stack_prefix']
    topic_arn = conf['topicarn']
    @ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
    @conf_instance = conf['author-primary']
    @task = 'export-packages'
    @parameters = { component:  @conf_instance['component'],
                    descriptor_file: 'stack-manager/export-backup-descriptor.json',
                    package_filter: 'package_filter' }
  end
  context 'Check if ssm command is successfull' do
    it 'should export packages' do
      result = @ssm_command.check(@task, @parameters)
      expect(result).to be == 'Success'
    end

    it 'should check if packages are exported' do
    end
  end
end
