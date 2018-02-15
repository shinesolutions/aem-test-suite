module Features
  module StackManagerTestHelper
    def aem_sm_conn
      sns_topic = @aem_sm_conf['sns_topic']
      aem_client = RubyAemAws::AemAws.new
      @aem_stack_manager_conn = aem_client.stack_manager(@stack_prefix, sns_topic)
    end

    def ec2_conn
      @aem_stack_manager_conn.ec2_client
    end

    def s3_conn
      @aem_stack_manager_conn.s3_client
    end

    def execute(task, parameters)
      dynamodb_tablename = @aem_sm_conf['dynamodb_tablename']
      # Should be at least the same, like timeout of cmd execution
      retry_opts = { max_tries: 5,
                     base_sleep_seconds: 5.0,
                     max_sleep_seconds: 15.5 }
      scan_retry_opts = retry_opts
      query_retry_opts = retry_opts
      @aem_stack_manager_conn.check(task, parameters, dynamodb_tablename, scan_retry_opts, query_retry_opts)
    end

    def live_snapshot_existens
      snapshot_type = 'live'
      snapshot_list = @aem_stack_manager_conn.ec2_snapshot_search(@stack_prefix, snapshot_type, @aem_component)
      snapshot_list['snapshots'].any?
    end
    # Not working yet... Check for artifacts is missing. Package check is working for artifact and artifacts.

    def deploy_artifacts_existens(descriptor_file, existens)
      file = Tempfile.new('descriptor_file')
      @aem_stack_manager_conn.s3_download(@s3_bucket_name, "#{@stack_prefix}/#{descriptor_file}", file)
      deploy_artifacts_descriptor_file = file.read
      file.unlink
      deploy_artifacts_hash_map = JSON.parse(deploy_artifacts_descriptor_file)
      exit_code = 0
      if deploy_artifacts_hash_map[@aem_component].include?('packages').eql? TRUE
        i = deploy_artifacts_hash_map[@aem_component]['packages'].length
        ii = 0
        while ii < i
          resp_code = page_package(deploy_artifacts_hash_map[@aem_component]['packages'][ii]['group'], deploy_artifacts_hash_map[@aem_component]['packages'][ii]['name'], deploy_artifacts_hash_map[@aem_component]['packages'][ii]['version'])
          exit_code += 1 unless resp_code.eql? 200
          if existens.eql? true
            puts "Error: Package #{deploy_artifacts_hash_map[@aem_component]['packages'][ii]['name']} not installed" unless exit_code.eql? 0
          end
          ii += 1
        end
      end
      if deploy_artifacts_hash_map[@aem_component].include?('artifacts').eql? TRUE
        i = deploy_artifacts_hash_map[@aem_component]['artifacts'].length
        ii = 0
        while ii < i
          resp_code = page_package(deploy_artifacts_hash_map[@aem_component]['artifacts'][ii]['group'], deploy_artifacts_hash_map[@aem_component]['artifacts'][ii]['name'], deploy_artifacts_hash_map[@aem_component]['artifacts'][ii]['version'])
          exit_code += 1 unless resp_code == 200
          if existens.eql? true
            puts "Error: ARtifact #{deploy_artifacts_hash_map[@aem_component]['artifacts'][ii]['name']} not installed" unless exit_code.eql? 0
          end
          ii += 1
        end
      end
      return TRUE unless exit_code != 0
    end
  end
end
