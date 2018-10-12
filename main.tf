provider "aws" {
  region =  "${var.aws_region}"
}
resource "aws_key_pair" "aws" {
   key_name = "aws"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCk9ErETxaJhxdj75c/C+yNvSPCfYkYtz66iKACt+bBzKjEPMvEJsugYPbX+23sUExevoMLT/EO0Hcd3gZsJgrxPKsI+y/49iuhygLxjaCz2BxLqUmbqRvIDqZrydcGPyK/OWPhkEthnfiPrrquchKbgHs8ZCfrpkzoiy2ISMTt6Q== amihai@amihai-lptp"
}
 # create a VPC to launch our instances into
resource "aws_vpc" "default" {
  cidr_block = "10.10.0.0/16"
  tags {
    Name = "test-crdfi"
  }
}
 # create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
    Name = "test-crdfi"
  }
}

# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

data "aws_vpc" "default" {
  filter {
      name   = "tag:Name"
      values = ["test-crdfi"]
   }
   depends_on = ["aws_vpc.default"]
}

# subnets def
resource "aws_subnet" "main" {
  count             = "${var.az_count}"
  cidr_block        = "10.10.1.0/24"
  availability_zone = "${var.availability_zones[0]}"
  vpc_id            = "${aws_vpc.default.id}"
}
resource "aws_subnet" "sec" {
  count             = "${var.az_count}"
  cidr_block        = "10.10.2.0/24"
  availability_zone = "${var.availability_zones[1]}"
  vpc_id            = "${aws_vpc.default.id}"
}


resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
}

resource "aws_route_table_association" "a" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.r.id}"
}
resource "aws_route_table_association" "b" {
  count          = "${var.az_count}"
  subnet_id      = "${element(aws_subnet.main.*.id, count.index)}"
  route_table_id = "${aws_route_table.r.id}"
}


# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "elb" {
  name        = "web_elb_sg"
  vpc_id      = "${aws_vpc.default.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Our default security group to access
# the instances over SSH and HTTP
resource "aws_security_group" "default" {
  name        = "web_sg"
  vpc_id      = "${aws_vpc.default.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # HTTP access from the VPC
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

 # Create a new load balancer

resource "aws_elb" "web" {
  name                  = "web-nginx-elb"
  subnets         = ["${aws_subnet.main.id}", "${aws_subnet.sec.id}"]
  security_groups = ["${aws_security_group.elb.id}"]
  #availability_zones    = ["${var.availability_zones}"]
  listener {
    instance_port       = 80
    instance_protocol   = "http"
    lb_port             = 80
    lb_protocol         = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
    Name                      = "web_nginx_elb"
  }
  depends_on = ["aws_instance.web", "aws_subnet.main"]
}


# Instance with all needed to web service
# including user data script  userdata.tpl to collect from s3
resource "aws_instance" "web" {
  # lookup for correct ami
  ami          = "ami-05d380e8adebba246"
  # The name of our SSH keypair we created above.
  key_name = "${aws_key_pair.aws.key_name}"
  associate_public_ip_address = "true"
  connection {
    # The default username for our AMI
    user = "ubuntu"

    # The connection will use the local SSH agent for authentication.
  }
  timeouts {
    create = "60m"
    delete = "60m"
  }
  instance_type = "t2.micro"
  monitoring = "true"
  count             = "${var.az_count}"
  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id = "${aws_subnet.main.id}"
  tags {
       name = "crdfi-test-origin"
  }
   #user_data = "${file("${path.module}/userdata.tpl")}"
   provisioner "remote-exec" {
     inline = [
       "sudo apt-get -y update",
       #"sudo apt-get -y install nginx",
       #"sudo service nginx start"
       ]
    }
}
### add s3 bucket and file
#resource "aws_s3_bucket" "b" {
#  bucket = "webpage-nay"
#  acl    = "public-read"
#}

#resource "aws_s3_bucket_object" "object" {
#  bucket = "webpage-nay"
#  key    = "index.html"
#  source = "./index.html"
#  etag   = "${md5(file("./index.html"))}"
#}

# Create A route 53 'A' record for our web server and attach public ipaddr
#resource "aws_zone" "primary" {
#  name = "probizit.org"
#}
data "aws_route53_zone" "primary" {
 name = "probizit.org"
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.primary.id}"
  name    = "www.${data.aws_route53_zone.primary.name}"
  type    = "CNAME"
  alias {
    name                   = "${aws_elb.web.dns_name}"
    zone_id                = "${aws_elb.web.zone_id}"
    evaluate_target_health = "false"
  }
  depends_on = ["aws_instance.web", "aws_elb.web"]
}

###for future use ###
#data "aws_instance" "web" {

#  filter {
#    name   = "tag:Name"
#    values = ["sometagvalue"]
#  }

#}

resource "aws_launch_configuration" "nginx" {
	name          = "web_config"
	image_id = "ami-05d380e8adebba246"
	instance_type = "t2.micro"
  lifecycle {
    create_before_destroy = true
  }
}


 # Create Autoscaling group policy
resource "aws_autoscaling_policy" "asg_pol" {
  policy_type 		 = "TargetTrackingScaling"
  name                   = "web_asg_pol"
  scaling_adjustment     = 3
  adjustment_type     = "ExactCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.web_nginx.name}"
  target_tracking_configuration {
  	predefined_metric_specification {
    	predefined_metric_type = "ASGAverageCPUUtilization"
  	}
  	target_value = 40.0
  }
}

resource "aws_autoscaling_group" "web_nginx" {
  name                      = "web_nginx_asg"
  availability_zones = ["eu-west-1a", "eu-west-1b"]
  desired_capacity = 1
  max_size = 3
  min_size = 1
  launch_configuration = "${aws_launch_configuration.nginx.id}"
    initial_lifecycle_hook {
      name                 = "life_cycle_web"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 2000
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
    }
    initial_lifecycle_hook {
      name                 = "death_cycle_web"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 3600
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    }
   depends_on = ["aws_instance.web", "aws_elb.web"]

}

# Create Autoscaling group attachment

resource "aws_autoscaling_attachment" "asg_attachment_web" {
  autoscaling_group_name = "${aws_autoscaling_group.web_nginx.id}"
  elb                    = "${aws_elb.web.id}"
  depends_on = ["aws_instance.web", "aws_elb.web", "aws_autoscaling_group.web_nginx"]
}
