require_relative '../spec_helper'

describe 'Content publishing', type: :feature do
  before :each do
    @conf = read_config
    @aem_author = init_author_client(@conf['aem']['author'])
    init_dispatcher_client(@conf['aem']['dispatcher'])
  end

  it 'should install and replicate the content package' do
    # download content package
    version = @conf['content_package']['version']
    content_package_url = format(@conf['content_package']['url'], version: version)
    FileUtils.mkdir_p @conf['tmp_dir']
    File.write("#{@conf['tmp_dir']}/aem-helloworld-content-#{@conf['content_package']['version']}.zip", Net::HTTP.get(URI.parse(content_package_url)))

    # install and replicate content package
    package = @aem_author.package('shinesolutions', 'aem-helloworld-content', @conf['content_package']['version'])
    results = []
    results.push(package.upload_wait_until_ready(@conf['tmp_dir'].to_s, retry_opts))
    results.push(package.install_wait_until_ready(retry_opts))
    results.push(package.replicate)
    result_handler(results)
  end

  it 'should verify the content in the replicated content package' do
    visit '/content/helloworld.html'
    expect(page).to have_content 'It\'s not a bug it\'s a feature'
  end

  it 'should verify the content redirected from rewrite rule with path' do
    visit '/cafe/helloworld'
    expect(page).to have_content 'It\'s not a bug it\'s a feature'
  end

  it 'should verify the content redirected from rewrite rule without path' do
    visit '/cafe-helloworld'
    expect(page).to have_content 'It\'s not a bug it\'s a feature'
  end
end
