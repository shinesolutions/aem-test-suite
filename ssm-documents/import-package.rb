require_relative '../spec_helper' 
require 'aws-sdk-sns'
require 'aws-sdk-dynamodb'
require 'phantomjs'
require 'retries'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		@conf = read_config['aem']
                @stack_prefix = @conf['stack_prefix']
                @conf_instance = @conf['author-primary']
                @component = @conf_instance['component']

		@sns_client = Aws::SNS::Topic.new(@conf['topicarn'])
                @dynamodb = Aws::DynamoDB::Client.new()
	end
	context 'Publish a message to SNS and check execution status' do
		# Need to declare strings as empty strings here, so they can passed through further tests
		publish_msg_id = 'empty'
		command_id = 'empty'
		ssm_state = 'empty'
		it 'should publish a message to SNS' do
			sns_client_publish = @sns_client.publish({
				subject: "Test Import Package",
                                message: "{ \"default\": \"{ 'task': 'import-package', 'stack_prefix': '#{@stack_prefix}, 'details': { 'component': '#{@component}', 'package_group': package_group, 'package_name': package_name, 'package_datestamp': package_datestamp }}\"}",
				message_structure: "json",
			})
			publish_msg_id = sns_client_publish.message_id
			expect(publish_msg_id).not_to be_empty
		end

		it 'should lookup if command was received ' do
			with_retries(:max_tries => 3, :base_sleep_seconds => 5.0, :max_sleep_seconds => 15.0) do|attempt_number|
				puts "Check if message was received by Lambda function: #{attempt_number}"
			        dynamodb_out = @dynamodb.scan( {
					table_name: "#{@stack_prefix}-AemStackManagerTable",
					attributes_to_get: ['command_id'],
					scan_filter: {
						"message_id" => {
							attribute_value_list: [publish_msg_id],
							comparison_operator: "EQ",
						},
					},
				})
				command_id = dynamodb_out.items[0]["command_id"]
				expect(command_id).not_to be_empty
			end
		end

                it 'should lookup if command was executed' do
			with_retries(:max_tries => 3, :base_sleep_seconds => 5.0, :max_sleep_seconds => 15.0) do|attempt_number|
				puts "Check if message was executed by Lambda function: #{attempt_number}"
				dynamodb_out = @dynamodb.query ({ 
					table_name: "#{@stack_prefix}-AemStackManagerTable",
					attributes_to_get: ['state'],
					key_conditions: {
						"command_id" => {
							attribute_value_list: [command_id],
                                                        comparison_operator: "EQ",
						},
					},
					query_filter: {
                                                "state" => {
							# Valied states are Pending, Success, Failed
                                                        attribute_value_list: ['Pending'],
                                                        comparison_operator: "NE",
                                                },
                                        },
				})
				ssm_state = dynamodb_out.items[0]["state"]
			end
			# Expect State Success
			expect(ssm_state).to eq("Success")
		end
	end
	#context 'Check if Package is imported now ' do
		#it 'should Check if artifacts are deployed' do
			#with_retries(:max_tries => 3, :base_sleep_seconds => 15.0, :max_sleep_seconds => 30.0) do|attempt_number|
			#end
		#end
	#end
end
