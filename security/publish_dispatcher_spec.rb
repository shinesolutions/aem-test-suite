require_relative '../spec_helper'

describe 'Publish-Dispatcher', type: :feature do
  before :each do
    @conf = read_config
    init_dispatcher_client(@conf['aem']['dispatcher'])
  end

  it 'should prevent clickjacking' do
    visit '/content/helloworld.html'
    expect(response_headers['X-Frame-Options']).to eq('SAMEORIGIN')
  end
end
