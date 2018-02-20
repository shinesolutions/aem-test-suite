# Copyright 2018 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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

    def page_author
      sign_in
      page.status_code
    end
  end
end
