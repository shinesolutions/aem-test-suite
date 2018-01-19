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

  it 'should prevent access to secure routes' do
    Dir.chdir(File.dirname(__FILE__))
    secure_urls=File.readlines("secure_public_routes.txt")
    #check each url
    secure_urls.each do |url|
      visit url
      expect(page.status_code).to eq(404)
    end
  end
end
