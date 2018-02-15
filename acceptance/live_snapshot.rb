require_relative '../spec_helper'

describe 'AEM', type: :feature do
  let(:task) { 'live-snapshot' }
  let(:parameters) { { component: @aem_component } }

  before do
    init_stack_manager_config
    aem_sm_conn
  end

  describe 'when no live snapshots exists' do
    it { expect(live_snapshot_existens).to be_falsey }
    context 'when creating live snapshot' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
  end
  describe 'when created live snapshot exist' do
    it { expect(live_snapshot_existens).to be_truthy }
  end
end
