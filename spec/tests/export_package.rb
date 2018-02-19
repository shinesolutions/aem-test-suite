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

shared_examples_for 'exporting a package' do
  let(:task) { 'export-package' }
  let(:parameters) {
    { component: @instance.descriptor.ec2.component,
      package_group: 'shinesolutions',
      package_name: 'aem-helloworld-content',
      package_filter: [{ root: '/content/helloworld', 'rules': [] }] }
  }
  before do
    init_stack_manager_config
  end

  describe 'when package not exported' do
    it { expect(export_package_existens(parameters[:package_group], parameters[:package_name]).exists?).to be_falsey }
    context 'should export package' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
  end
  describe 'when package exported' do
    context 'should export package' do
      it { expect(export_package_existens(parameters[:package_group], parameters[:package_name]).exists?).to be_truthy }
    end
  end
end
