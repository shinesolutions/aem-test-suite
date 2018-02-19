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
  module StackManagerTestHelper

    def execute(task, parameters)
      init_ruby_aem_aws
      # Should be at least the same, like timeout of cmd execution
      retry_opts = { max_tries: 3,
                     base_sleep_seconds: 5.0,
                     max_sleep_seconds: 15.5 }
      scan_retry_opts = retry_opts
      query_retry_opts = retry_opts
      message_id = @aem_stack_manager_conn.sm_resources.sns_publish(@sns_topic, task, @stack_prefix, parameters)

      with_retries(scan_retry_opts) do
        @cmd_id = @aem_stack_manager_conn.sm_resources.dyn_db_msg_scan(@dynamodb_tablename, message_id)
      end

      with_retries(query_retry_opts) do
        @state = @aem_stack_manager_conn.sm_resources.dyn_db_cmd_query(@dynamodb_tablename, @cmd_id)
      end

        return TRUE unless @state.eql? 'Failed'
    end

    def author_instance_exist(instances_count)
      instance = 0
      instance += 1  unless @aem_full_set.author.author_primary.healthy?.eql? false
      instance += 1  unless @aem_full_set.author.author_standby.healthy?.eql? false
      puts instance
      return true unless instance < instances_count
    end

    def live_snapshot_existens
      snapshot_type = 'live'
      @instance.snapshot?(snapshot_type)
    end

    def terminate_author_primary
      @aem_full_set.author.terminate_primary_instance
    end

    def author_elb
      @aem_full_set.author.describe_loadbalancer.load_balancer_descriptions[0].dns_name
    end

    def export_package_existens(package_group, package_name)
      time =  Time.new
      package_source = "backup/#{@stack_prefix}/#{package_group}/#{time.strftime("%Y/%m")}/#{package_name}-#{time.strftime("%Y%m%d")}-#{@instance.descriptor.ec2.component}.zip"
      @aem_stack_manager_conn.sm_resources.s3_resource_object(@s3_bucket_name, package_source)
    end

    # Check for artifacts is not implemented yet
    def export_packages_existens(descriptor_file)
      time =  Time.new
      file = Tempfile.new('descriptor_file')
      @aem_stack_manager_conn.sm_resources.s3_download_object(@s3_bucket_name, "#{@stack_prefix}/#{descriptor_file}", file)
      export_packages_descriptor_file = file.read
      export_packages_hash_map = JSON.parse(export_packages_descriptor_file)
      exit_code = 0
      if export_packages_hash_map[@instance.descriptor.ec2.component].include?('packages').eql? TRUE
        i = export_packages_hash_map[@instance.descriptor.ec2.component]['packages'].length
        ii = 0
        while ii < i
          package_group = export_packages_hash_map[@instance.descriptor.ec2.component]['packages'][ii]['group']
          package_name = export_packages_hash_map[@instance.descriptor.ec2.component]['packages'][ii]['name']
          package_source = "backup/#{@stack_prefix}/#{package_group}/#{time.strftime("%Y/%m")}/#{package_name}-#{time.strftime("%Y%m%d")}-#{@instance.descriptor.ec2.component}.zip"
          existens = @aem_stack_manager_conn.sm_resources.s3_resource_object(@s3_bucket_name, package_source).exists?
          exit_code += 1 unless existens.eql? true
          ii += 1
        end
      end
      return TRUE unless exit_code != 0
    end

    def packages_existens(descriptor_file)
      file = Tempfile.new('descriptor_file')
      @aem_stack_manager_conn.sm_resources.s3_download_object(@s3_bucket_name, "#{@stack_prefix}/#{descriptor_file}", file)
      deploy_artifacts_descriptor_file = file.read
      deploy_artifacts_hash_map = JSON.parse(deploy_artifacts_descriptor_file)
      exit_code = 0
      if deploy_artifacts_hash_map[@instance.descriptor.ec2.component].include?('packages').eql? TRUE
        i = deploy_artifacts_hash_map[@instance.descriptor.ec2.component]['packages'].length
        ii = 0
        while ii < i
          resp_code = page_package(deploy_artifacts_hash_map[@instance.descriptor.ec2.component]['packages'][ii]['group'], deploy_artifacts_hash_map[@instance.descriptor.ec2.component]['packages'][ii]['name'], deploy_artifacts_hash_map[@instance.descriptor.ec2.component]['packages'][ii]['version'])
          exit_code += 1 unless resp_code.eql? 200
          ii += 1
        end
      end
      return TRUE unless exit_code != 0
    end
  end
end
