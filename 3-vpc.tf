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

# source "aws_db_subnet_group" "rds_subnet_group" {
#   name       = "vitalpbx-subnet-group"
#   subnet_ids = [aws_subnet.vitalpbx_subnet.id, aws_subnet.vitalpbx_subnet_privada.id]

#   tags = {
#     Name = "vitalpbx RDS Subnet Group"
#   }
# }re
