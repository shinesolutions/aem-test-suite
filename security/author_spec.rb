require_relative '../spec_helper'

describe 'Author', type: :feature do
  before :each do
    @conf = read_config
    @aem_author = init_author_client(@conf['aem']['author'])
    init_web_client(@conf['aem']['author'])
  end

  it 'should not be able to make api calls using default credentials' do
    # use aem api calls
    aem = @aem_author.aem
    begin
      result = aem.get_agents('author')
    rescue RubyAem::Error => error
      # response should be unauthorized
      expect(error.result.response.status_code).to eq(401)
    end
    # no result due to error raised
    expect(result).to eq(nil)
  end

  it 'should not be able to login using default admin password' do
    visit '/libs/granite/core/content/login.html'
    fill_in('username', with: 'admin')
    fill_in('password', with: 'admin')
    click_button('submit-button')
    error = find('#error').text
    expect(error).to eq('User name and password do not match')
  end
end
