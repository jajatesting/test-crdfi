variable "public_key_path" {
  description = <<DESCRIPTION
PUT YOUR KEY PATH HERE (after DESCRIPTION)
Example: ~/.ssh/webkey.pub
DESCRIPTION
  type = "map"
  default = {
    rsh = "~/.ssh/aws.pub"
    ec2 = "~/proj/crdfi/final/key"
  }
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "1"
}
variable "availability_zones" {
  default     = ["eu-west-1a", "eu-west-1b"]
  description = "List of availability zones, use AWS CLI to find your "
}


variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

# Ubuntu  18.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-674cbc1e"
    #for future use #us-east-1 = "ami-1d4e7a66"
    #for future use #us-west-1 = "ami-969ab1f6"
    #for future use #us-west-2 = "ami-8803e0f0"
  }
}
variable "az_numbers" {
  default = {
    a = 1
    b = 2
    c = 3
    d = 4
    e = 5
    f = 6
    g = 7
    h = 8
    i = 9
    j = 10
    k = 11
    l = 12
    m = 13
    n = 14
  }
}
