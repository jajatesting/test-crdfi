Exmple OF Usage for Terraform for Aws Provider.
  
	here you can find a way to recreate entire network in aws with oen click .
	the network consist of : 
	vpc,elb,asg,sg,nginx,s3bucket,route53 zone and alias 
	and of course connectivity and dep between them!!!
	
	enjoy!!!
	
	please install prerequisits:

	python3  + boto3
	pip
	awscli

	1. need an amazone account preffered in eu-west-1 with ac2-full access + s3 full access + route53 full access
	2. configure your account and region ( current file-set is designed for eu-west1)
	3. generate sshkeygen -t rsa -b1024 , and assign it to main.tf ,the pub file need to assign as a valid key in your aws 		   account
	3. run the aws.py for starting proccess ,
	   it will create s3 bucket ("<CHANGEME>webpage-crdifi") and route53 zone.
	4. pull with git clone https://github.com/jajatesting/test-crdfi.git
	5. run terrform init && terrafrom plan && terraform apply
	
	variables.tf 
	file for variables of your network.
	
	some variable not yet seperated.... sorry about that
	
