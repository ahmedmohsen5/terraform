

resource "aws_db_subnet_group" "terra-rds-subgrp" {
  name = "main"
  subnet_ids = [module.VPC.private_subnets[0] , module.VPC.private_subnets[1] , module.VPC.private_subnets[2]]
  tags = {
    Name = "Subnet group for RDS"
  }
}


resource "aws_elasticache_subnet_group" "terra-ecache-subgrp" {
  name = "terra-ecache-subgrp"
  subnet_ids = [module.VPC.private_subnets[0] , module.VPC.private_subnets[1] , module.VPC.private_subnets[2]]
  tags = {
    Name = "Subnet group for ECACHE"
  }
}

resource "aws_db_instance" "terra-rds" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "8.0.32"
  instance_class = "db.t2.micro"
  db_name = var.dbname
  username = var.dbuser
  password = var.dbpass
  parameter_group_name = "default.mysql8.0"
  multi_az = "false"
  publicly_accessible = "false"
  skip_final_snapshot = true 
  db_subnet_group_name = aws_db_subnet_group.terra-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.terra-backend-sg.id]
}

resource "aws_elasticache_cluster" "terra-cache" {
  cluster_id = "terra-cache"
  engine = "memcached"
  node_type = "cache.t2.micro"
  parameter_group_name = "default.memcached1.6"
  port = 11211
  security_group_ids = [ aws_security_group.terra-backend-sg.id ]
  subnet_group_name = aws_elasticache_subnet_group.terra-ecache-subgrp.name
}

resource "aws_mq_broker" "terra-rmq" {
  broker_name = "terra-rmq"
  engine_type = "ActiveMQ"
  host_instance_type = "mq.t2.micro"
  security_groups = [aws_security_group.terra-backend-sg.id]
  subnet_ids = [module.VPC.private_subnets[0]]
  engine_version = "5.15.0"
  user {
    password = var.rmqpass
    username = var.rmquser
  }
}