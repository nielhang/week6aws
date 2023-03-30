
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

# Define random password for Directory Service
resource "random_password" "rpwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
