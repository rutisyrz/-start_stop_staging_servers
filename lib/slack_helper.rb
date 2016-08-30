class SlackHelper
	
	def initialize
		@notifier = Slack::Notifier.new "YOUR_SLACK_WEB_HOOK_URL"
	end

	def send_aws_notification(message)
		@notifier.channel  = '#YOUR_SLACK_CHANNEL_NAME'
		@notifier.username = 'aws-notifier'
		@notifier.ping message
	end
end