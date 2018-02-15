require_relative '../spec_helper'

describe 'AEM', type: :feature do
  let(:task) { 'enable-crxde' }
  let(:parameters) { { component: @aem_component } }

  before do
    init_stack_manager_config
    aem_sm_conn
    sign_in
  end

  after do
    sign_out
  end

  describe 'when crxde is unreachable' do
    it { expect(page_crxde).to eql(404) }
    context 'when crxde is enabled' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
  end
  describe 'when crxde is reachable' do
    it { expect(page_crxde).to eql(200) }
  end
end
