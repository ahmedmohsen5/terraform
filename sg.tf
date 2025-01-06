resource "aws_security_group" "terra-bean-elb-sg" {
  name        = "terra-bean-elb-sg"
  description = "Security group for bean-elb"
  vpc_id      = module.VPC.vpc_id
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "terra-bastion-sg" {
  name        = "terra-bastion-sg"
  description = "Security group for bastionisioner ec2 instance"
  vpc_id      = module.VPC.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "terra-prod-sg" {
  name        = "terra-prod-sg"
  description = "Security group for beanstalk instances"
  vpc_id      = module.VPC.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.terra-bean-elb-sg.id]
  }
}

resource "aws_security_group" "terra-backend-sg" {
  name   = "terra-backend-sg"
  vpc_id = module.VPC.vpc_id
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [ aws_security_group.terra-prod-sg.id ]
  }
  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = [ aws_security_group.terra-bastion-sg.id ]
  }
}

resource "aws_security_group_rule" "sec_group_allow_itself" {
  from_port = 0
  to_port = 65535
  type = "ingress"
  security_group_id = aws_security_group.terra-backend-sg.id
  source_security_group_id = aws_security_group.terra-backend-sg.id
  protocol = "tcp"
}
