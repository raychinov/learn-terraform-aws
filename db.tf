resource "random_password" "db_pass" {
  length           = 20
  special          = false
#  override_special = "_%@"
}

#resource "aws_db_instance" "mysql" {
#  allocated_storage      = 20
#  storage_type           = "gp2"
#  engine                 = "mysql"
##  engine_version         = "5.7"
#  instance_class         = "db.t2.micro"
#  name                   = "wp_db"
#  username               = "wp_user"
#  publicly_accessible    = false
#  password               = random_password.db_pass.result
#  parameter_group_name   = "default.mysql5.7"
##  vpc_security_group_ids = [module.app_security_group.this_security_group_id,
##                           module.db_security_group.this_security_group_id]
##  db_subnet_group_name   = module.db_security_group.this_security_group_name
##  security_groups        = [module.db_security_group.this_security_group_id]
##  vpc_security_group_ids = [aws_security_group.mysql.id] 
##  db_subnet_group_name   = aws_db_subnet_group.mysql.name
#  skip_final_snapshot    = true
#  vpc_security_group_ids = [module.app_security_group.this_security_group_id,
#                            module.db_security_group.this_security_group_id,
#                            aws_security_group.mysql.id]
##  security_groups = [module.app_security_group.this_security_group_id,
##                            module.db_security_group.this_security_group_id,
##                            aws_security_group.mysql.id]
# # subnet_id              = module.vpc.public_subnets[count.index % length(module.vpc.public_subnets)]
#
#
#}

resource "aws_db_instance" "mysql" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  identifier = "blue-db"
  name                   = "wp_db"
  username               = "wp_user"
  publicly_accessible    = false
  password               = random_password.db_pass.result
  skip_final_snapshot = true
  tags = {
    Name = "blue-db-instance"
  }

  vpc_security_group_ids = [module.app_security_group.this_security_group_id]
#  db_subnet_group_name   = module.app_security_group.this_security_group_name
#  db_subnet_group_name   = aws_db_subnet_group.mysql.name 
#  vpc_security_group_ids = [aws_security_group.mysql.id]  
#  db_subnet_group_name = aws_db_subnet_group.main.id
#  vpc_security_group_ids = [module.app_security_group.this_security_group_id]  
  db_subnet_group_name = aws_db_subnet_group.main.id

}

resource "aws_db_subnet_group" "main" {
  name = "db-private-subnets"
#  subnet_ids = module.vpc.public_subnets
  subnet_ids = module.vpc.private_subnets
  tags = {
    Name = "db-subnet-group-blue"
  }
}
