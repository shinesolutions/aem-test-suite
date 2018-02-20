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

shared_examples_for 'promoting author primary to standby' do
  let(:task) { 'promote-author' }
  let(:parameters) { { component: @instance.descriptor.ec2.component } }

  before do
    init_stack_manager_config
  end

  describe 'when all author instances are available', type: :feature do
    it { expect(author_instance_exist(2)).to be_truthy }
    context 'author login' do
      it { expect(page_author).to eql(200) }
    end

    context 'should terminate author primary instance' do
      it { expect(terminate_author_primary).to be_truthy }
    end

    context 'author login' do
      it { expect(page_author).to eql(404) }
    end

    context 'promote author primary to standby' do
      it { expect(execute(task, parameters)).to be_truthy }
    end

    context 'author login' do
      it { expect(page_author).to eql(200) }
    end

    context 'one author instance available' do
      it { expect(author_instance_exist(1)).to be_truthy }
    end
  end
end
