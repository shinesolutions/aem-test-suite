require_relative '../spec_helper'

describe 'Publish-Dispatcher', type: :feature do
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
    secure_urls = File.readlines('security/publish_pages_and_scripts.txt')
    secure_urls.each do |url|
      visit url
      # follow redirect since Capybara does not do this automatically
      visit response_headers['Location'] if response_headers.key?('Location')
      # wait for page load to prevent missing checks - https://stackoverflow.com/questions/36108196/how-to-get-poltergeist-phantomjs-to-delay-returning-the-page-to-capybara-until-a
      page.has_content?('.+')
      expect(page.status_code).to eq(404)
    end
  end

  it 'should deny access to root directories of /etc and /libs' do
    visit '/etc/'
    expect(page.status_code).to eq(404)
    visit '/libs/'
    expect(page.status_code).to eq(404)
  end

  it 'should not be able to invalidate Dispatcher cache' do
    # set http headers to invalidate cache
    headers = { 'CQ-Handle' => '/content', 'CQ-Path' => '/content' }
    Capybara.current_session.driver.add_headers(headers)
    visit('/dispatcher/invalidate.cache')
    # according to Adobe specs - https://helpx.adobe.com/experience-manager/dispatcher/using/dispatcher-configuration.html
    # response should be 404 but its forbidden instead
    expect(page.status_code).to eq(403)
  end
end
