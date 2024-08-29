resource "aws_vpc" "vitalpbx" {
  cidr_block           = "172.31.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "vitalpbx VPC"
  }

}
resource "aws_subnet" "vitalpbx_subnet" {
  vpc_id            = aws_vpc.vitalpbx.id
  cidr_block        = "172.31.36.0/28"
  availability_zone = "us-east-2a"

  tags = {
    Name = "vitalpbx SUBNET"
  }

}

resource "aws_subnet" "vitalpbx_subnet_privada" {
  vpc_id            = aws_vpc.vitalpbx.id
  cidr_block        = "172.31.37.0/28"
  availability_zone = "us-east-2b"

  tags = {
    Name = "vitalpbx SUBNET Privada"
  }

}

resource "aws_internet_gateway" "vitalpbx_gw" {
  vpc_id = aws_vpc.vitalpbx.id
  tags = {
    Name = "vitalpbx_GW"
  }
}

resource "aws_route_table" "tabla_enruta_default_vitalpbx" {
  vpc_id = aws_vpc.vitalpbx.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vitalpbx_gw.id
  }
  tags = {
    Name = "tabla_enruta_default_vitalpbx"
  }

}

resource "aws_route_table" "tabla_enruta_default_vitalpbx_private" {
  vpc_id = aws_vpc.vitalpbx.id
  
  tags = {
    Name = "tabla_enruta_default_vitalpbx_private"
  }

}

resource "aws_route_table_association" "assocition_tabla_enruta_default" {
  subnet_id      = aws_subnet.vitalpbx_subnet.id
  route_table_id = aws_route_table.tabla_enruta_default_vitalpbx.id
}

resource "aws_route_table_association" "private-assocition_tabla" {
  subnet_id      = aws_subnet.vitalpbx_subnet_privada.id
  route_table_id = aws_route_table.tabla_enruta_default_vitalpbx_private.id
}


resource "aws_security_group" "sg_vitalpbx" {
  name        = "sg_vitalpbx"
  description = "Server vitalpbx"
  vpc_id = aws_vpc.vitalpbx.id
  
  tags = {
    Name = "vitalpbx_gs"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5060
    to_port     = 5061
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10000
    to_port     = 20000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "vitalpbx-subnet-group"
  subnet_ids = [
    aws_subnet.vitalpbx_subnet.id,        # Asegúrate de que ambas subredes estén aquí
    aws_subnet.vitalpbx_subnet_privada.id  # Asegúrate de que ambas subredes estén aquí
  ]

  tags = {
    Name = "vitalpbx RDS Subnet Group"
  }
}


 
resource "aws_security_group" "sg_rds_vitalpbx" {
  name        = "vitalpbx-db-sg"
  vpc_id = aws_vpc.vitalpbx.id
  ingress {
    from_port   = 3306  # MySQL port
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.sg_vitalpbx.id]
  }
}
