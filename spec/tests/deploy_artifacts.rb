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

shared_examples_for 'deploying packages and artifacts' do
  let(:task) { 'deploy-artifacts' }
  let(:parameters) {
    { component: @instance.descriptor.ec2.component,
      descriptor_file: 'descriptor/deploy-artifacts-descriptor.json' }
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
      it { expect(packages_existens(parameters[:descriptor_file])).to be_falsey }
    end
    context 'when no package exist deploy' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
    context 'when package exist' do
      it { expect(packages_existens(parameters[:descriptor_file])).to be_truthy }
    end
  end
end
