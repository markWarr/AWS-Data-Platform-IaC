resource "aws_emr_studio" "emr_studio" {
  auth_mode                   = "IAM"
  default_s3_location         = "s3://${var.s3_emr_studio_name}"
  engine_security_group_id    = aws_security_group.EMREngineSecurityGroup.id
  name                        = "emr_studio"
  service_role                = aws_iam_role.iam_emr_studio_role.arn
  subnet_ids                  = [aws_subnet.main.id]
  vpc_id                      = aws_vpc.main.id
  workspace_security_group_id = aws_security_group.EMRWorkspaceSecurityGroupGit.id
  tags                        = {}
}