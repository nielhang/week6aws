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
