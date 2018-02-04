require_relative '../spec_helper'

describe 'Publish', type: :feature do
  before :each do
    @conf = read_config
    @aem_publish = init_publish_client(@conf['aem']['publish'])

  end

  it 'should not be able to login using default admin password' do
    # use aem api calls
    bundle = @aem_publish.bundle('com.adobe.cq.social.cq-social-forum')
    begin
      result = bundle.start
    rescue RubyAem::Error => error
      # response should be unauthorized
      # checking for 500 since a NoAuthenticationHandlerException Java Exception is thrown, thus a server error
      expect(error.result.response.status_code).to eq(500)
    end
    # no result due to error raised
    expect(result).to eq(nil)
  end
end
