require_relative '../spec_helper'
describe 'AEM', type: :feature do
  let(:task) { 'deploy-artifact' }
  let(:parameters) {
    { component: @aem_component,
      source:     's3://aem-stack-builder/library/aem-helloworld-content-0.0.1-SNAPSHOT.zip',
      group:      'shinesolutions',
      name:       'aem-helloworld-content',
      version:    '0.0.1-SNAPSHOT',
      replicate:  'true',
      activate:   'false',
      force:      'true' }
  }
  before do
    init_stack_manager_config
    aem_sm_conn
    sign_in
  end
  after do
    sign_out
  end
  describe 'deploy package' do
    context 'when package not exist' do
      it { expect(page_package(parameters[:group], parameters[:name], parameters[:version])).to eql(404) }
    end
    context 'when no package exist deploy' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
    context 'when package exist' do
      it { expect(page_package(parameters[:group], parameters[:name], parameters[:version])).to eql(200) }
    end
  end
end
