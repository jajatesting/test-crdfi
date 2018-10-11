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
variable "aws_key_aws" {
   type = "string"
   default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCk9ErETxaJhxdj75c/C+yNvSPCfYkYtz66iKACt+bBzKjEPMvEJsugYPbX+23sUExevoMLT/EO0Hcd3gZsJgrxPKsI+y/49iuhygLxjaCz2BxLqUmbqRvIDqZrydcGPyK/OWPhkEthnfiPrrquchKbgHs8ZCfrpkzoiy2ISMTt6Q== amihai@amihai-lptp"
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
variable "aws_key_ec2" {
  type  = "string"
  default = <<EOF
  -----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQCk9ErETxaJhxdj75c/C+yNvSPCfYkYtz66iKACt+bBzKjEPMvE
JsugYPbX+23sUExevoMLT/EO0Hcd3gZsJgrxPKsI+y/49iuhygLxjaCz2BxLqUmb
qRvIDqZrydcGPyK/OWPhkEthnfiPrrquchKbgHs8ZCfrpkzoiy2ISMTt6QIDAQAB
AoGAFHm6eimzC3k4XxBTfuD1CRcMRE0e4nGEmNTyv8OiIjZMUKeXR47lQdAnc+Hi
4C2LfUs6qwHOU19vGccAlxYVz28FTXa6MvLLbEm3K6LwHtpSDsQUOIfeCBTx4JI0
0/KkI6OyENvxo6p4ovha82w3+K2muMPO9SZv9ZL+JyOPGZ0CQQDTytGqzPOrQl6V
sAxmlrbKCjTSSEO/0MuyYbdz52nPJEwtJ+gdJPs6lTRpHwuIvCso1y8juP6ESjQ8
69M9ujU7AkEAx2Krz6hrgQau8yMdOg3NheA1TCojs5bT3FEeUg2AcmICJHF0Rdm4
7Yb/ObcVlDuxhsTMQGkbGLlJcEiAFwYnKwJBALWvrxAEBCDtrbBhtzGmpyZJfSjL
n3sExkm/tB307nspm0O9kUy3NeH6r1xiqoVhTvEZMDJH9+dKtOdyMuQoQpMCQQC9
pmQoTFmdS78jM7Y8Hx7rhV0MylRVIVT5jgsaHw+bPRAum9/uBO86t5qSykvzSGhO
+WgSqCcG+E8bR0rXG5orAkB8ZlcOryMaw/vfE1OFKupdCPOYe5MGCeHMJz7Jc6gS
tXEUWa9nx+nS/ehxXZyWDnrRbZnBpHd5fNHQ1ZFYIBVw
-----END RSA PRIVATE KEY-----
EOF
}
