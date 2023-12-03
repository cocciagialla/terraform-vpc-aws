data "aws_availability_zones" "available" {}

locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k)]
  cluster_name = var.cluster_name
  tags = {
    env         = var.environment
    repo        = var.cluster_repo
    repo_ver    = var.cluster_repo_ver
    project     = var.project_name
  }
}

#---------------------------------------------------------------
# Supporting Resources
#---------------------------------------------------------------

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name = local.cluster_name
  cidr = var.vpc_cidr

  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = var.create_private_subnets ? local.private_subnets : []

  enable_nat_gateway      = var.create_private_subnets ? true : false
  single_nat_gateway      = false
  one_nat_gateway_per_az  = true
  enable_dns_hostnames    = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.cluster_name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.cluster_name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.cluster_name}-default" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }

  tags = local.tags

#  # Cloudwatch log group and IAM role will be created
#  enable_flow_log                      = true
#  create_flow_log_cloudwatch_log_group = true
#  create_flow_log_cloudwatch_iam_role  = true
#
#  flow_log_max_aggregation_interval         = 60
#  flow_log_cloudwatch_log_group_name_prefix = "/vpc-flow-logs/"
#  flow_log_cloudwatch_log_group_name_suffix = "${local.cluster_name}"
#
#  vpc_flow_log_tags = local.tags
}
