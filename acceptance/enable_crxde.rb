require_relative '../spec_helper'

describe 'AEM Author', type: :feature do
  let(:url) { "/crx/server/crx.default/jcr:root/.1.json" }
  let(:task) { 'enable-crxde' }
  let(:parameters) { { component: 'author-primary' } }

  before do
    init_stack_manager_config()
    sign_in
  end

  after do
    sign_out
  end

  describe 'test if crxde is disabled' do
    it { expect(visit_page(url)).to eql(404) }

    context 'when crxde is disabled' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
  end

  describe 'when crxde is enabled' do
      it { expect(visit_page(url)).to eql(200) }
  end
end
