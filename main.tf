provider "aws" {
    region = "eu-west-3"
}

variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

resource "aws_vpc" "devops_main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "devopswave VPC"
    }
}

resource "aws_subnet" "public_subnets" {
    count            = length(var.public_subnet_cidrs)
    vpc_id           = aws_vpc.devops_main.id
    cidr_block       = element(var.public_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)

    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}

resource "aws_subnet" "private_subnets" {
    count            = length(var.private_subnet_cidrs)
    vpc_id           = aws_vpc.devops_main.id
    cidr_block       = element(var.private_subnet_cidrs, count.index)
    availability_zone = element(var.azs, count.index)

    tags = {
        Name = "Private Subnet ${count.index + 1}"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.devops_main.id

    tags = {
        Name = "devopswave VPC IG"
    }
}

resource "aws_route_table" "second_rt" {
    vpc_id = aws_vpc.devops_main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }

    tags = {
        Name = "2nd Route Table"
    }
}

resource "aws_route_table_association" "public_subnet_asso" {
    count          = length(var.public_subnet_cidrs)
    subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
    route_table_id = aws_route_table.second_rt.id
}

resource "aws_security_group" "instance_sg" {
    name        = "devopswave-test-sg"
    description = "Security group for devopswave test instances"
    vpc_id      = aws_vpc.devops_main.id

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "my_ec2_instance" {
    ami           = "ami-01d21b7be69801c2f"
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.public_subnets[0].id

    vpc_security_group_ids = [aws_security_group.instance_sg.id]

    associate_public_ip_address = true

    user_data = <<-EOF
        #!/bin/bash
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo systemctl start apache2
        sudo systemctl enable apache2
        echo "<h1>Hello devopswaver's</h1>" | sudo tee /var/www/html/index.html
    EOF

    tags = {
        Name = "devopswave test"
    }
}

resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for RDS DB instance"
  vpc_id      = aws_vpc.devops_main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db_sg"
  }
}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {

  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.default.name

  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "15.6"
  instance_class       = "db.t3.micro"
  identifier           = "madb"
  username             = "adolfo"
  password             = "adolfo2barros"
  parameter_group_name = "default.postgres15"
  skip_final_snapshot  = true

  tags = {
    Name = "My DB Instance"
  }
}

output "instance_public_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.my_ec2_instance.public_ip
}

output "instance_private_ip" {
  description = "The private IP of the instance"
  value       = aws_instance.my_ec2_instance.private_ip
}

output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.default.address
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.default.arn
}

output "db_instance_name" {
  description = "The name of the RDS instance"
  value       = aws_db_instance.default.identifier
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.default.endpoint
}

