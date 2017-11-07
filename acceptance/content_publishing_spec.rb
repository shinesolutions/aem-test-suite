require_relative 'spec_helper'

describe 'Content publishing', :type => :feature do

  before :each do
    @conf = read_config
    @aem_author = init_author_client
    init_dispatcher_client
  end

  it 'should download a test package' do
    version = @conf['test_package']['version']
    test_package_url = @conf['test_package']['url'] % { :version => version }
    FileUtils.mkdir_p @conf['tmp_dir']
    File.write("#{@conf['tmp_dir']}/aem-helloworld-content-#{@conf['test_package']['version']}.zip", Net::HTTP.get(URI.parse(test_package_url)))
  end

  it 'should install and replicate the test package' do
    package = @aem_author.package('shinesolutions', 'aem-helloworld-content', @conf['test_package']['version'])
    results = []
    results.push(package.upload_wait_until_ready("#{@conf['tmp_dir']}", retry_opts))
    results.push(package.install_wait_until_ready(retry_opts))
    results.push(package.replicate)
    result_handler(results)
  end

  it 'should verify the content in the replicated test package' do
    visit '/content/helloworld'
    expect(page).to have_content 'a feature'
  end

end
