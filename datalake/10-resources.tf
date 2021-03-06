resource "aws_security_group" "allow_access" {
  name        = "allow_access"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [aws_subnet.main]

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

  tags = {
    name = "emr_test"
  }
}

resource "aws_security_group" "EMREngineSecurityGroup" {
name        = "EMREngineSecurityGroup"
  description = "Allow only outbound traffic"
  vpc_id      = aws_vpc.main.id
  depends_on = [aws_subnet.main]

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

  tags = {
    for-use-with-amazon-emr-managed-policies="true"
  }
}

# This ingress security group rule isn't directly included in the EMREngineSecurityGroup definition since doing so creates a circular reference 
# between security groups which Terraform can't handle. This is the suggested workaround. 
resource "aws_security_group_rule" "allow_emr_workspace" {
    type = "ingress"
    from_port = 18888
    to_port = 18888
    protocol = "tcp"
    security_group_id = aws_security_group.EMREngineSecurityGroup.id
    source_security_group_id = aws_security_group.EMRWorkspaceSecurityGroupGit.id
}

resource "aws_security_group" "EMRWorkspaceSecurityGroupGit" {
  name        = "EMRWorkspaceSecurityGroupGit"
  description = "Allows outbound traffic from Amazon EMR Studio Workspaces to clusters and publicly-hosted Git repos."
  vpc_id      = aws_vpc.main.id

  egress     = [
           {
               cidr_blocks      = [
                   "0.0.0.0/0",
                ]
               description      = "Required for Amazon EMR Studio Workspace and Git communication."
              from_port        = 443
               ipv6_cidr_blocks = []
               prefix_list_ids  = []
               protocol         = "tcp"
               security_groups  = []
               self             = false
               to_port          = 443
            },
           {
               cidr_blocks      = []
               description      = "Required for Amazon EMR Studio Workspace and cluster communication."
               from_port        = 18888
              ipv6_cidr_blocks = []
              prefix_list_ids  = []
               protocol         = "tcp"
               security_groups  = [
                   aws_security_group.EMREngineSecurityGroup.id,
                ]
               self             = false
               to_port          = 18888
            },
        ] 

  depends_on = [aws_subnet.main]

  lifecycle {
    ignore_changes = [
      ingress,
      egress,
    ]
  }

  tags = {
    for-use-with-amazon-emr-managed-policies="true"
  }  
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = {
    name = "emr_test"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_subnet1_cidr_block

  tags = {
    name = "emr_test"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "r" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.r.id
}

###

# IAM Role setups

###

# IAM role for EMR Service
resource "aws_iam_role" "iam_emr_service_role" {
  name = "iam_emr_service_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM role ploicy for EMR Service
resource "aws_iam_role_policy" "iam_emr_service_policy" {
  name = "iam_emr_service_policy"
  role = aws_iam_role.iam_emr_service_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:AuthorizeSecurityGroupEgress",
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:CancelSpotInstanceRequests",
            "ec2:CreateNetworkInterface",
            "ec2:CreateSecurityGroup",
            "ec2:CreateTags",
            "ec2:DeleteNetworkInterface",
            "ec2:DeleteSecurityGroup",
            "ec2:DeleteTags",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeDhcpOptions",
            "ec2:DescribeInstanceStatus",
            "ec2:DescribeInstances",
            "ec2:DescribeKeyPairs",
            "ec2:DescribeNetworkAcls",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribePrefixLists",
            "ec2:DescribeRouteTables",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeSpotInstanceRequests",
            "ec2:DescribeSpotPriceHistory",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcAttribute",
            "ec2:DescribeVpcEndpoints",
            "ec2:DescribeVpcEndpointServices",
            "ec2:DescribeVpcs",
            "ec2:DetachNetworkInterface",
            "ec2:ModifyImageAttribute",
            "ec2:ModifyInstanceAttribute",
            "ec2:RequestSpotInstances",
            "ec2:RevokeSecurityGroupEgress",
            "ec2:RunInstances",
            "ec2:TerminateInstances",
            "ec2:DeleteVolume",
            "ec2:DescribeVolumeStatus",
            "ec2:DescribeVolumes",
            "ec2:DetachVolume",
            "iam:GetRole",
            "iam:GetRolePolicy",
            "iam:ListInstanceProfiles",
            "iam:ListRolePolicies",
            "iam:PassRole",
            "s3:CreateBucket",
            "s3:Get*",
            "s3:List*",
            "sdb:BatchPutAttributes",
            "sdb:Select",
            "sqs:CreateQueue",
            "sqs:Delete*",
            "sqs:GetQueue*",
            "sqs:PurgeQueue",
            "sqs:ReceiveMessage"
        ]
    }]
}
EOF
}

# IAM role for EMR Studio
resource "aws_iam_role" "iam_emr_studio_role" {
  name = "iam_emr_studio_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticmapreduce.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# IAM role policy for EMR Studio
# see https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-studio-service-role.html
resource "aws_iam_role_policy" "iam_emr_studio_policy" {
  name = "iam_emr_studio_policy"
  role = aws_iam_role.iam_emr_studio_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "ec2:CreateNetworkInterface", 
            "ec2:CreateNetworkInterfacePermission", 
            "ec2:DeleteNetworkInterface", 
            "ec2:DeleteNetworkInterfacePermission", 
            "ec2:DescribeNetworkInterfaces", 
            "ec2:ModifyNetworkInterfaceAttribute", 
            "ec2:AuthorizeSecurityGroupEgress", 
            "ec2:AuthorizeSecurityGroupIngress", 
            "ec2:CreateSecurityGroup",
            "ec2:DescribeSecurityGroups", 
            "ec2:RevokeSecurityGroupEgress",
            "ec2:DescribeTags",
            "ec2:DescribeInstances",
            "ec2:DescribeSubnets",
            "ec2:DescribeVpcs",
            "elasticmapreduce:ListInstances", 
            "elasticmapreduce:DescribeCluster", 
            "elasticmapreduce:ListSteps",
            "secretsmanager:GetSecretValue",
            "ec2:CreateTags",
            "s3:PutObject",
            "s3:GetObject",
            "s3:GetEncryptionConfiguration",
            "s3:ListBucket",
            "s3:DeleteObject",
            "iam:GetUser",
            "iam:GetRole",
            "iam:ListUsers",
            "iam:ListRoles",
            "sso:GetManagedApplicationInstance",
            "sso-directory:SearchUsers"
        ]
    }]
}
EOF
}

# IAM Role for EC2 Instance Profile
resource "aws_iam_role" "iam_emr_profile_role" {
  name = "iam_emr_profile_role"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "emr_profile" {
  name = "emr_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

# IAM Role policy for EC2 Instance Profile
resource "aws_iam_role_policy" "iam_emr_profile_policy" {
  name = "iam_emr_profile_policy"
  role = aws_iam_role.iam_emr_profile_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Resource": "*",
        "Action": [
            "cloudwatch:*",
            "dynamodb:*",
            "ec2:Describe*",
            "elasticmapreduce:Describe*",
            "elasticmapreduce:ListBootstrapActions",
            "elasticmapreduce:ListClusters",
            "elasticmapreduce:ListInstanceGroups",
            "elasticmapreduce:ListInstances",
            "elasticmapreduce:ListSteps",
            "kinesis:CreateStream",
            "kinesis:DeleteStream",
            "kinesis:DescribeStream",
            "kinesis:GetRecords",
            "kinesis:GetShardIterator",
            "kinesis:MergeShards",
            "kinesis:PutRecord",
            "kinesis:SplitShard",
            "rds:Describe*",
            "s3:*",
            "sdb:*",
            "sns:*",
            "sqs:*"
        ]
    }]
}
EOF
}

# IAM role for lambda
resource "aws_iam_role" "lambda_role" {
name   = "Data_Init_Lambda_Function_Role"
assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

# IAM role policy for lambda
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_terraform_aws_lambda_role"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents",
       "s3:PutObject",
       "s3:GetObject"       
     ],
     "Resource": [
        "arn:aws:logs:*:*:*",
        "arn:aws:s3:::${var.s3_emr_studio_name}/*",
        "arn:aws:s3:::${var.s3_emr_studio_name}"
     ],
     "Effect": "Allow"
   }
 ]
}
EOF
}

# IAM role policy attachment for lambda
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}