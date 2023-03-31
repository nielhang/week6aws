data "aws_s3_bucket" "bkt" {
  bucket = var.s3-bucket-name
}

resource "aws_cloudtrail" "logs" {
  name                          = "${var.common-name-prefix}.logs"
  s3_bucket_name                = data.aws_s3_bucket.bkt.id
  s3_key_prefix                 = "prefix"
  include_global_service_events = false
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [data.aws_s3_bucket.bkt.arn]
  }

  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${data.aws_s3_bucket.bkt.arn}/prefix/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

resource "aws_s3_bucket_policy" "bkt" {
  bucket = data.aws_s3_bucket.bkt.id
  policy = data.aws_iam_policy_document.policy.json
}


resource "aws_vpc" "main" {
  # Your VPC must have DNS hostname and DNS resolution support. 
  # Otherwise, your worker nodes cannot register with your cluster. 

  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                            = "${var.common-name-prefix}.vpc"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
  }
}

# Create the private subnet
resource "aws_subnet" "eks" {
  count             = length(var.vpc_availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.vpc_cidr_block_private_subnets, count.index)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name                                            = "${var.common-name-prefix}.eks"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"               = 1
  }
}

# Create the public subnet
resource "aws_subnet" "appgwy" {
  count             = length(var.vpc_availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.vpc_cidr_block_public_subnets, count.index)
  availability_zone = element(var.vpc_availability_zones, count.index)

  tags = {
    Name                                            = "${var.common-name-prefix}.appgwy"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                        = 1
  }

  map_public_ip_on_launch = true
}

# Create IGW for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common-name-prefix}.igwy"
  }
}

# Route the public subnet traffic through the IGW
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = element(var.vpc_cidr_block_any, 0)
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.common-name-prefix}.rt"
  }
}

# Route table and subnet associations
resource "aws_route_table_association" "public" {
  count          = length(var.vpc_availability_zones)
  subnet_id      = aws_subnet.appgwy[count.index].id
  route_table_id = aws_route_table.main.id
}

# Create Elastic IP
resource "aws_eip" "main" {
  vpc = true
}

# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.main.id
  subnet_id     = aws_subnet.appgwy[0].id

  tags = {
    Name = "NAT Gateway for Custom Kubernetes Cluster"
  }
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = element(var.vpc_cidr_block_any, 0)
  nat_gateway_id         = aws_nat_gateway.main.id
}