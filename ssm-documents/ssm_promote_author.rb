require_relative '../spec_helper' 
require 'aws-sdk-sns'
require 'aws-sdk-cloudwatchlogs'
require 'phantomjs'

describe 'Test functionallity of stack-manager', type: :feature do
	before :all do
		@conf = read_config['aem']
		@sns_client = Aws::SNS::Topic.new(@conf['topicarn'])
		@cw = Aws::CloudWatchLogs::Client.new
		@component = 'author-primary'
	end

	it 'should publish a message to Stack-Manager SNS topic and send it to instance' do
		# Publish Message to SNS
                sns_client_publish = @sns_client.publish({
                        subject: "Test EnableCRXDE",
                        message: "{ \"default\": \"{ 'task': 'promote-crxde', 'stack_prefix': '#{@conf['stack_prefix']}', 'details': { 'component': '#{@component}' }}\"}",
                        message_structure: "json",
                })
                publish_msg_id = sns_client_publish.message_id
		cw_log_filter = publish_msg_id.gsub('-', ' ')
		sleep 5
		# Search Cloudwatch for message id
		cw_sn_ev = @cw.filter_log_events({
			log_group_name: "/aws/lambda/#{@conf['stack_prefix']}-AemStackManager",
			filter_pattern: "#{cw_log_filter}",
			limit: 1,
		})
		msg_arr = cw_sn_ev.events[0].message.split("\t")
		msg = msg_arr[2]
		sleep 15
		# After a wait time of 15 second check if command was successfully sent
		cw_ssm = @cw.filter_log_events({
                        log_group_name: "/aws/lambda/#{@conf['stack_prefix']}-AemStackManager",
                        filter_pattern: "calling ssm commands #{msg}",
                        limit: 1,
                })
	end
        it 'Check if CRXDE ist enabled' do
	end
end
