# start_stop_staging_servers
Script to auto Start/Stop AWS EC2 instances used for Staging environment during non-productive hours

## Required gems 
- aws-sdk, slack-notifier, whenever

## Setup code

- bundle install

- Add your AWS account details in file
	- /config/initializer/aws.rb

- Add your Slack account details in file
	- /lib/slack_helper.rb

- Modify cron schedule as per your need in file
	- /config/schedule.rb

- Tag EC2 instances
	- To execute this script, you need to associate tag name=environment and value=staging with all staging app servers

## How is this useful?

- AWS charges per hour price for On-Demand EC2 instances. So it's better to STOP staging servers that we use for QA during non-working hours to save the cost.
