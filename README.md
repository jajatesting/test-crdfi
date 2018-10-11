#####
###   this file explain the usage of main.tf and variables.tf.


	prerequisits:

	python 3
	pip
	awscli

	1. amazone account preffered in eu-west-1 with ac2-full access + s3 full access + route53 full access
	2. configure your account and region ( current file-set is designed for eu-west1)
	3. run the aws.py for starting proccess ,
	   it will create s3 bucket ("webpage-crdifi") and route53 zone.
	4. pull with git clone https://github.com/jajatesting/test-crdfi.git
	5. run terrform init && terrafrom plan && terraform apply
	6. you can also browse the web for probizit.org

