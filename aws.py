#!/usr/bin/python3
import boto3

s3 = boto3.client('s3')
s3.create_bucket(Bucket='webpage-nay')
open('index.html').write('<html><body><h1>Testing the nginx deploy</h1></body></html>')
s3out= s3.upload_file('index.html', 'webpage-nay', 'index.html')
print (s3out)

r53 = boto3.client('route53')
responsezone = r53.create_hosted_zone(
   Name='some-domain',
   CallerReference='zone for crdfi'
    )

#print (responsezone)

#download terraform
#from subprocess import call
#call(["wget", "https://releases.hashicorp.com/terraform/0.11.8/terraform_0.11.8_linux_amd64.zip"])

#extract terraform
#from subprocess import call
#call(["unzip", "terraform_0.11.8_linux_amd64.zip"])

#from subprocess import call
##call(["./terraform", "init"])
