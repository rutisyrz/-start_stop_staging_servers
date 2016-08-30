Aws.config.update({
	region: "YOUR_AWS_REGION",
  credentials: Aws::Credentials.new("YOUR_AWS_ACCESS_KEY", "YOUR_AWS_SECRET_ACCESS_KEY") 
})

def aws_region
	Aws.config[:region]
end

def aws_credentials
	Aws.config[:credentials]
end
