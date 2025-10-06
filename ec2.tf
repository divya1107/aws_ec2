resource "aws_instance" "terraform_secnd_ec2" {
  ami             = "ami-00ca32bbc84273381"
  instance_type   = "t2.micro"
  count           = 0
  security_groups = [aws_security_group.trfm_sg.name]
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
            EOF
  tags = {
    Name = "terraform_secnd_ec2"
  }
}

resource "aws_security_group" "trfm_sg" {
  name        = "trfm_sg"
  description = "Allow  inbound traffic and all outbound traffic"
  vpc_id      = "vpc-0e350024825fb4528"

  tags = {
    Name = "trfm_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.trfm_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1"
}