require_relative '../spec_helper'
require_relative '../../ruby_aem_aws/lib/ruby_aem_aws/component/stack_manager'

describe 'Test functionallity of stack-manager', type: :feature do
  before :all do
    conf = read_config['aem']
    stack_prefix = conf['stack_prefix']
    topic_arn = conf['topicarn']
    @ssm_command = RubyAemAws::Component::StackManagerTest.new(topic_arn, stack_prefix)
    @conf_instance = conf['author-primary']
    @task = 'deploy-artifact'
    @parameters = { component: @conf_instance['component'],
                    source:     's3://aem-stack-builder/library/aem-helloworld-content-0.0.1-SNAPSHOT.zip',
                    group:      'shinesolutions',
                    name:       'aem-helloworld-content',
                    version:    '0.0.1-SNAPSHOT',
                    replicate:  'true',
                    activate:   'false',
                    force:      'true' }
  end

  context 'Check if ssm command is successfull' do
    it 'should deploy artifact' do
      result = @ssm_command.check(@task, @parameters)
      expect(result).to be == 'Success'
    end

    it 'should check if artifact is deployed' do
    end
  end
end
