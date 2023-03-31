# Security group for public subnet resources
resource "aws_security_group" "public_sg" {
  name   = "${var.common-name-prefix}.public.sg"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common-name-prefix}.public.sg"
  }
}

# Security group traffic rules
## Ingress rule
resource "aws_security_group_rule" "ingress_public_443" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.vpc_cidr_block_any
}

resource "aws_security_group_rule" "ingress_public_80" {
  security_group_id = aws_security_group.public_sg.id
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = var.vpc_cidr_block_any
}

## Egress rule
resource "aws_security_group_rule" "egress_public" {
  security_group_id = aws_security_group.public_sg.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.vpc_cidr_block_any
}

# Security group for data plane
resource "aws_security_group" "data_plane" {
  name   = "${var.common-name-prefix}.k8s.dp"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common-name-prefix}.k8s.dp"
  }
}

# Security group traffic rules
## Ingress rule
resource "aws_security_group_rule" "nodes" {
  description       = "Allow nodes to communicate with each other"
  security_group_id = aws_security_group.data_plane.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = flatten([var.vpc_cidr_block_private_subnets, var.vpc_cidr_block_public_subnets])
}

resource "aws_security_group_rule" "nodes_inbound" {
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  security_group_id = aws_security_group.data_plane.id
  type              = "ingress"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([var.vpc_cidr_block_private_subnets])
}

## Egress rule
resource "aws_security_group_rule" "node_outbound" {
  security_group_id = aws_security_group.data_plane.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.vpc_cidr_block_any
}

# Security group for control plane
resource "aws_security_group" "control_plane" {
  name   = "${var.common-name-prefix}.k8s.cp"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.common-name-prefix}.k8s.cp"
  }
}

# Security group traffic rules
## Ingress rule
resource "aws_security_group_rule" "control_plane_inbound" {
  security_group_id = aws_security_group.control_plane.id
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = flatten([var.vpc_cidr_block_private_subnets, var.vpc_cidr_block_public_subnets])
}

## Egress rule
resource "aws_security_group_rule" "control_plane_outbound" {
  security_group_id = aws_security_group.control_plane.id
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.vpc_cidr_block_any
}