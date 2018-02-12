require_relative '../spec_helper'

describe 'AEM Author', type: :feature do
  let(:task) { 'deploy-artifact' }
  let(:parameters) { { component: @conf_instance['component'],
                      source:     's3://aem-stack-builder/library/aem-helloworld-content-0.0.1-SNAPSHOT.zip',
                      group:      'shinesolutions',
                      name:       'aem-helloworld-content',
                      version:    '0.0.1-SNAPSHOT',
                      replicate:  'true',
                      activate:   'false',
                      force:      'true' } }
  before :all do
    init_stack_manager_config()
  end
  describe '' do
  context 'Check if ssm command is successfull' do
      it { expect(execute(task, parameters)).to be_truthy }
  end
end
