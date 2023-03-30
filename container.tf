
# Define container registry
resource "aws_ecr_repository" "ecr" {
  name                 = var.container-registry-name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.common-name-prefix}.vpc"
  }
}

resource "aws_subnet" "aks" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.1.0/24"
  tags              = { Name = "${var.common-name-prefix}.aks" }
}

resource "aws_subnet" "appgwy" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.2.0/24"
  tags              = { Name = "${var.common-name-prefix}.appgwy" }
}
