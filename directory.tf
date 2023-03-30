
# Define Active Directory Service
resource "aws_directory_service_directory" "adsd" {
  name     = "${var.common-name-prefix}.aks.group"
  password = random_password.rpwd.result
  size     = "Small"

  vpc_settings {
    vpc_id     = aws_vpc.main.id
    subnet_ids = [aws_subnet.ds1.id, aws_subnet.ds2.id]
  }

  tags = {
    Project = var.common-name-prefix
  }
}

# Define IAM Group
resource "aws_iam_group" "grp" {
  name = "${var.common-name-prefix}.aks.group"
}

# Retrieve Existing Users
data "aws_caller_identity" "current" {}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

# Define IAM Group Membership
resource "aws_iam_user_group_membership" "owner" {
  user = split("/", split(":", data.aws_caller_identity.current.arn)[5])[1]

  groups = [
    aws_iam_group.grp.name,
  ]
}

# Attach Existing Policy to the Group
resource "aws_iam_group_policy_attachment" "policy" {
  group      = aws_iam_group.grp.name
  policy_arn = var.group-policy-arn
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${var.common-name-prefix}.vpc"
  }
}

resource "aws_subnet" "ds1" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "ds2" {
  vpc_id            = aws_vpc.main.id
  availability_zone = "eu-west-1b"
  cidr_block        = "10.0.2.0/24"
}

# Define random password for Directory Service
resource "random_password" "rpwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
