resource "aws_security_group" "db" {
  name        = "${var.name_prefix}-db-sg"
  description = "Allow MySQL from WAS SG"
  vpc_id      = var.vpc_id

  ingress {
    description      = "MySQL from WAS"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups  = [var.was_sg_id]  # Spring 서버 SG에서만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-db-sg"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnet-group"
  }
}

resource "aws_db_instance" "this" {
  identifier        = "${var.name_prefix}-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"
  db_name           = var.db_name
  username          = var.username
  password          = var.db_password
  port              = 3306

  multi_az               = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot    = true

  tags = {
    Name = "${var.name_prefix}-mysql"
  }
}
