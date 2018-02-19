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

shared_examples_for 'instance to deploy an artifact' do
  let(:task) { 'deploy-artifact' }
  let(:parameters) {
    { component: @instance.descriptor.ec2.component,
      source:     's3://aem-stack-builder/library/aem-helloworld-content-0.0.1-SNAPSHOT.zip',
      group:      'shinesolutions',
      name:       'aem-helloworld-content',
      version:    '0.0.1-SNAPSHOT',
      replicate:  'true',
      activate:   'false',
      force:      'true' }
  }

  before do
    init_stack_manager_config
    sign_in
  end
  after do
    sign_out
  end
  describe 'deploy package', type: :feature do
    context 'when package not exist' do
      it { expect(page_package(parameters[:group], parameters[:name], parameters[:version])).to eql(404) }
    end
    context 'when no package exist deploy', type: :feature do
      it { expect(execute(task, parameters)).to be_truthy }
    end
    context 'when package exist', type: :feature do
      it { expect(page_package(parameters[:group], parameters[:name], parameters[:version])).to eql(200) }
    end
  end
end
