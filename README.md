# start_stop_staging_servers
Script to auto Start/Stop AWS EC2 instances used for Staging environment during non-productive hours.
You can schedule this script on your Production server.

## How is this useful?

- AWS charges per hour price for On-Demand EC2 instances. So it's better to STOP staging servers that we use for QA during non-working hours to save the cost.

## Required gems 
- [aws-sdk](https://rubygems.org/gems/aws-sdk), [slack-notifier](https://rubygems.org/gems/slack-notifier), [whenever](https://rubygems.org/gems/whenever)

## Prerequisite

- Create a channel in your Slack account in which you want to receive Server Start/Stop notifications
- Tag EC2 instances
	- To execute this script, you need to associate tag **name=environment** and **value=staging** with all staging app servers

## Setup code

- Install bundle
```ruby
bundle install
```

- Add your AWS account details in file */config/initializer/aws.rb*
```ruby
Aws.config.update({
	region: "YOUR_AWS_REGION",
 	credentials: Aws::Credentials.new("YOUR_AWS_ACCESS_KEY", "YOUR_AWS_SECRET_ACCESS_KEY") 
})
```

- Add your Slack account details in file */lib/slack_helper.rb*
```ruby
@notifier = Slack::Notifier.new "YOUR_SLACK_WEB_HOOK_URL"
```

```ruby
@notifier.channel  = '#YOUR_SLACK_CHANNEL_NAME'
```

- Modify cron schedule as per your need in file */config/schedule.rb*
- In this sample app, I've set Servers Start time as 10:00 AM and 07:00 PM
```ruby
every '* 10,19 * * 1,2,3,4,5' do
	rake 'cronjobs:start_stop_staging_servers'
end
```

- Update crontab file. Run command
```ruby
whenever --update-crontab
```
