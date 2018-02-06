require_relative '../spec_helper'

describe 'Publish', type: :feature do
  before :each do
    @conf = read_config
    @aem_publish = init_publish_client(@conf['aem']['publish'])
    init_web_client(@conf['aem']['publish'])
  end

  it 'should not be able to start bundle with default credentials' do
    # use bundle api calls
    bundle = @aem_publish.bundle('com.adobe.cq.social.cq-social-forum')
    begin
      result = bundle.start
    rescue RubyAem::Error => error
      # response should be not valid as per spec https://github.com/shinesolutions/ruby_aem/blob/master/conf/spec.yaml#L49
      expect(error.result.response.status_code).not_to eq(200)
      expect(error.result.response.status_code).not_to eq(404)
    end
    # no result due to error raised
    expect(result).to eq(nil)
  end

  it 'should not be able to login with default credentials' do
    visit '/libs/granite/core/content/login.html'
    fill_in('username', with: 'admin')
    fill_in('password', with: 'admin')
    click_button('submit-button')
    error = find('#error').text
    expect(error).to eq('User name and password do not match')
  end
end
