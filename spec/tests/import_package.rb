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

shared_examples_for 'instance to import a package' do
  let(:task) { 'import-package' }
  let(:parameters) {
    { component: @instance.descriptor.ec2.component,
      source_stack_prefix: @instance.descriptor.stack_prefix,
      package_group: 'shinesolutions',
      package_name: 'aem-helloworld-content',
      package_datestamp: Time.new.strftime('%Y%m') }
  }

  before do
    init_stack_manager_config
    sign_in
  end
  after do
    sign_out
  end
  describe 'import package', type: :feature do
    context 'should not exist' do
      it { expect(page_package(parameters[:package_group], parameters[:package_name], "#{parameters[:package_datestamp]}-#{@instance.descriptor.ec2.component}-latest")).to eql(404) }
    end
    context 'when no package exist', type: :feature do
      it { expect(execute(task, parameters)).to be_truthy }
    end
    context 'should exist', type: :feature do
      it { expect(page_package(parameters[:package_group], parameters[:package_name], "#{parameters[:package_datestamp]}-#{@instance.descriptor.ec2.component}-latest")).to eql(200) }
    end
  end
end
