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

require_relative '../spec_helper'
publish = RubyAemAws::Component::Publish.new(nil, nil, nil, nil)

describe publish do
  before :each do
    init_config
    @instance = @aem_full_set.publish
  end
  it_should_behave_like 'an disabled crxde instance'
  it_should_behave_like 'an enabled crxde instance'
  it_should_behave_like 'taking a live-snapshot'
end
