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

shared_examples_for 'an disabled crxde instance' do
  let(:task) { 'enable-crxde' }
  let(:parameters) {
    { component: @instance.descriptor.ec2.component }
  }

  before do
    init_stack_manager_config
    sign_in
  end

  after do
    sign_out
  end

  describe 'when crxde is disable', type: :feature do
    it { expect(page_crxde).to eql(404) }
  end
  describe 'when crxde is unreachable', type: :feature do
    context 'should enable crxde' do
      it { expect(execute(task, parameters)).to be_truthy }
    end
  end
  describe 'when crxde is reachable', type: :feature do
    it { expect(page_crxde).to eql(200) }
  end
end
