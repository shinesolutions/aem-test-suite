require_relative '../spec_helper'

describe 'Publish', type: :feature do
  before :each do
    @conf = read_config
    @aem_publish = init_publish_client(@conf['aem']['publish'])
  end

  it 'should not be able to login using default admin password' do
    # use aem api calls
    aem = @aem_publish.aem
    begin
      aem.get_agents('publish')
    rescue RubyAem::Error => error
      # response should be unauthorized
      expect(error.result.response.status_code).to eq(401)
    end
  end
end
