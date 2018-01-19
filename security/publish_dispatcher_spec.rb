require_relative '../spec_helper'

describe 'Publish-Dispatcher', type: :feature do
  # urlFile=File.new('secure_public_urls.txt','r');

  before :each do
    @conf = read_config
    init_dispatcher_client(@conf['aem']['dispatcher'])
  end

  it 'should set up DoS prevention by making /.json inaccessible' do
    visit '/.json'
    expect(page.status_code).to eq(404)
  end

  it 'should set up clickjacking prevention by setting X-Frame-Options header' do
    visit '/'
    expect(response_headers['X-Frame-Options']).to eq('SAMEORIGIN')
  end

  it 'should not be able to access Publish pages as site visitor' do
    secure_urls = File.readlines('security/secure_public_routes.txt')
    # check each url
    secure_urls.each do |url|
      visit url
      expect(page.status_code).to eq(404)
    end
  end

  it 'should not be able to invalidate Dispatcher cache' do
    # set http headers to invalidate cache
    headers = { 'CQ-Handle' => '/content', 'CQ-Path' => '/content' }
    Capybara.current_session.driver.add_headers(headers)
    visit('/dispatcher/invalidate.cache')
    expect(page.status_code).to eq(404)
  end
end
