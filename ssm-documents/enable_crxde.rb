require_relative '../spec_helper' 
require 'aws-sdk-sns'
require 'aws-sdk-cloudwatchlogs'
require 'phantomjs'
require 'retries'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		@conf = read_config['aem']
		@sns_client = Aws::SNS::Topic.new(@conf['topicarn'])
		@cw = Aws::CloudWatchLogs::Client.new
		#@component = ARGV
		@component = 'author-primary'
	end
	context 'Publish a message to SNS and check for execution ' do
		cw_sn_ev = @cw
		it 'should publish a message to SNS' do
			sns_client_publish = @sns_client.publish({
				subject: "Test EnableCRXDE",
				message: "{ \"default\": \"{ 'task': 'enable-crxde', 'stack_prefix': '#{@conf['stack_prefix']}', 'details': { 'component': '#{@component}' }}\"}",
				message_structure: "json",
			})
			publish_msg_id = sns_client_publish.message_id
			# Instead of looking into Cloudwatch to determine if the command was successfully sent. It might be better to look into the DynamoDB to see if the command failed or succeed
			cw_log_filter = publish_msg_id.gsub('-', ' ')
			with_retries(:max_tries => 3, :base_sleep_seconds => 5.0, :max_sleep_seconds => 15.0) do|attempt_number|
				puts "Check if message was received by Lambda function: #{attempt_number}"
				cw_sn_ev = @cw.filter_log_events({
					log_group_name: "/aws/lambda/#{@conf['stack_prefix']}-AemStackManager",
					filter_pattern: "#{cw_log_filter}",
					limit: 1,
				})
				cw_sn_ev = cw_sn_ev.events[0].message.split("\t")
			end
		end
		it 'should check if lambda executed the message' do
                        msg = cw_sn_ev[2]
			with_retries(:max_tries => 3, :base_sleep_seconds => 10.0, :max_sleep_seconds => 30.0) do|attempt_number|
				# Check if command was successfully sent
				puts "Check if message was executed by Lambda function: #{attempt_number}"
				cw_ssm = @cw.filter_log_events({
					log_group_name: "/aws/lambda/#{@conf['stack_prefix']}-AemStackManager",
					filter_pattern: "#{msg} calling ssm commands",
					limit: 1,
				})
			end
		end	
		it 'Check if CRXDE is enabled' do
			with_retries(:max_tries => 3, :base_sleep_seconds => 15.0, :max_sleep_seconds => 30.0) do|attempt_number|
				puts "Check if CRXDE is enabled: #{attempt_number}"
				init_poltergeist_client(@conf['author'])
				page.driver.basic_authorize(@conf['author']['username'], @conf['author']['password'])
				visit '/crx/server/crx.default/jcr:root/.1.json'
				expect(page.status_code).to eq(200)
			end
		end
	end
end
