
# Define IAM Group
resource "aws_iam_group" "grp" {
  name = "${var.common-name-prefix}.aks.group"
}

# Retrieve Existing Users
data "aws_caller_identity" "current" {}

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

resource "aws_iam_role" "eks_cluster" {
  name               = "${var.eks_cluster_name}-cluster"
  assume_role_policy = data.aws_iam_policy_document.assume_cluster.json
}

#https://docs.aws.amazon.com/eks/latest/userguide/worker_node_IAM_role.html
resource "aws_iam_role" "eks_nodes" {
  name               = "${var.eks_cluster_name}-worker"
  assume_role_policy = data.aws_iam_policy_document.assume_workers.json
}

data "aws_iam_policy_document" "assume_cluster" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "assume_workers" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "aws_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "aws_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "ec2_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

# Define random password for Directory Service
resource "random_password" "rpwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
