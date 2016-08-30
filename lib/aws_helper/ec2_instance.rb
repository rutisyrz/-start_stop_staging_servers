class AwsHelper::EC2Instance

	def initialize
		@ec2 = Aws::EC2::Resource.new(region: aws_region, credentials: aws_credentials)
	end

	def staging_servers
		# Filter servers with tag=environment and value=staging
		@ec2.instances({filters: [{name: 'tag:environment', values: ['staging']}]}).map {|i| i.id}
	end

	def stop(instance_id)
		instance = @ec2.instance(instance_id)
		# validate instance
		validation_result = validate_instance(instance)
		return validation_result if validation_result[:error].present?		
		# get current state of instance
		state = instance.state			
	  case state.code
	  when 0  # pending
	  	return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_pending", instance_id: instance_id)}, result: nil}		    
	  when 32  # shutting-down
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_shutting_down", instance_id: instance_id)}, result: nil}
	  when 48  # terminated
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_terminated", instance_id: instance_id)}, result: nil}
	  when 64  # stopping
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_stopping", instance_id: instance_id)}, result: nil}
	  when 80  # stopped
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_stopped", instance_id: instance_id)}, result: nil}
	  else
	    result = instance.stop
	    return {error: {}, result: result}
	  end
	end

	def start(instance_id)
		instance = @ec2.instance(instance_id)
		# validate instance
		validation_result = validate_instance(instance)
		return validation_result if validation_result[:error].present?		
		# get current state of instance
		state = instance.state
	  case state.code
	  when 0  # pending
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_pending", instance_id: instance_id)}, result: nil}
	  when 32  # shutting-down
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_shutting_down", instance_id: instance_id)}, result: nil}
	  when 16  # started
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_started", instance_id: instance_id)}, result: nil}
	  when 48  # terminated
	    return {error: {code: state.name, message: I18n.t("aws.ec2.errors.instance_terminated", instance_id: instance_id)}, result: nil}
	  else
	    result = instance.start
	    return {error: {}, result: result}
	  end		
	end	
	
	def validate_instance(instance)
		begin
			unless instance.exists?
				return {error: {code: I18n.t("aws.ec2.codes.not_found"), message: I18n.t("aws.ec2.errors.instance_not_exists", instance_id: instance_id)}}
			end
			return {error: {} }
		rescue Aws::EC2::Errors::InvalidInstanceIDMalformed => e
			return {error: {code: I18n.t("aws.common.codes.invalid_instance"), message: e.message}, result: []}
		rescue Exception => e
			return {error: {code: I18n.t("aws.common.codes.custom_exception"), message: I18n.t("aws.common.errors.custom_exception")}, result: []}
		end
	end
end