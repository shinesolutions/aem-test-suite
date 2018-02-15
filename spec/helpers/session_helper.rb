module Features
  module SessionHelper
    def visit_page(url)
      visit url
      page.status_code
    end

    def sign_in
      visit '/libs/granite/core/content/login.html'
      fill_in 'username', with: @user
      fill_in 'password', with: @password
      click_button 'submit-button'
    end

    def sign_out
      visit '/system/sling/logout.html'
    end

    def page_crxde
      visit_page('/crx/server/crx.default/jcr:root/.1.json')
    end

    def page_package(group, name, version)
      visit_page("/etc/packages/#{group}/#{name}-#{version}.zip")
    end

    def page_package_list
      visit_page('/crx/packmgr/list.jsp')
    end
  end
end
