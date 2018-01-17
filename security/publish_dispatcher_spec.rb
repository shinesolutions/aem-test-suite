require_relative '../spec_helper'

describe 'Publish-Dispatcher', type: :feature do
  before :each do
    @conf = read_config
    init_dispatcher_client(@conf['aem']['dispatcher'])
  end

  it 'should set up DoS prevention by making /.json inaccessible' do
  end

  it 'should set up clickjacking prevention by setting X-Frame-Options header' do
    visit '/'
    expect(response_headers['X-Frame-Options']).to eq('SAMEORIGIN')
  end
end
