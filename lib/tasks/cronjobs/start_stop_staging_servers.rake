# Run this cron at 10 AM IST and 7 PM IST to Start and Stop staging app servers
# Do not run it on Sat and Sun
namespace :cronjobs do
	desc "rake RAILS_ENV=development cronjobs:start_stop_staging_servers"
	task :start_stop_staging_servers => :environment do |t|
		curr_time = Time.zone.now
		## Do not run it on Sat and Sun
		abort("Its weekend! Have a fun!") if ["saturday, sunday"].include? (curr_time.strftime("%A").downcase)	
		abort("Not a right time!") unless [10, 19].include? (curr_time.hour)

		ec2 = AwsHelper::EC2Instance.new
		errors = []
		
		ec2.staging_servers.each do |instance_id|
			result = 	case curr_time.hour
								when 10
									# start servers
									ec2.start(instance_id)
								when 19
									# end servers
									ec2.stop(instance_id)
								end	
			# Collect errors
			errors.push(result[:error][:message]) if result[:error].present?
		end

		# Notify Result on Slack
		message = "AWS EC2 instances (Staging) have been #{curr_time.hour == 10 ? 'Started' : 'Stopped'}."
		message += " \n Errors- #{errors.join(', ')}" if errors.present?
		SlackHelper.new().send_aws_notification(message)		
	end
end
