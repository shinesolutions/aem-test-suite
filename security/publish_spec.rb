require_relative '../spec_helper'

describe 'Publish', type: :feature do
  before :each do
    @conf = read_config
    @aem_publish = init_publish_client(@conf['aem']['publish'])
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
end
