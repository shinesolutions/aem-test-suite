require_relative '../spec_helper'

describe 'Author', type: :feature do
  before :each do
    @conf = read_config
    @aem_author = init_author_client(@conf['aem']['author'])
  end

  it 'should not be able to login using default admin password' do
    # use aem api calls
    aem = @aem_author.aem
    begin
      aem.get_agents('author')
    rescue RubyAem::Error => error
      # response should be unauthorized
      expect(error.result.response.status_code).to eq(401)
    end
  end
end
