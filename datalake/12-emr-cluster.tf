resource "aws_emr_cluster" "cluster" {
  name          = "emr-test-arn-madeTech"
  release_label = "emr-5.35.0"
  applications  = ["Spark"]
  log_uri       = "s3://madetech-emr-log-bucket/elasticmapreduce/"
  
  ec2_attributes {
    subnet_id                         = aws_subnet.main.id
    emr_managed_master_security_group = aws_security_group.allow_access.id
    emr_managed_slave_security_group  = aws_security_group.allow_access.id
    instance_profile                  = aws_iam_instance_profile.emr_profile.arn
  }
 
  master_instance_group {
    instance_type = var.EMR_instance_type
  }

  core_instance_group {
    instance_count = 1
    instance_type  = var.EMR_instance_type
  }

  tags = {
    role     = "rolename"
    dns_zone = "env_zone"
    env      = "env"
    name     = "name-env"
  }

  bootstrap_action {
    path = "s3://elasticmapreduce/bootstrap-actions/run-if"
    name = "runif"
    args = ["instance.isMaster=true", "echo running on master node"]
  }


  step {
    action_on_failure = "TERMINATE_CLUSTER"
    name              = "Setup Hadoop Debugging"

    hadoop_jar_step {
      jar  = "command-runner.jar"
      args = ["state-pusher-script"]
    }
  }

  # Optional: ignore outside changes to running cluster steps. 
  #  It is highly recommended to utilize the lifecycle configuration block with 
  #  ignore_changes if other steps are being managed outside of Terraform. 
  lifecycle {
    ignore_changes = [step]
  }

  configurations_json = <<EOF
  [
    {
      "Classification": "hadoop-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64"
          }
        }
      ],
      "Properties": {}
    },
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0-amazon-corretto.x86_64"
          }
        }
      ],
      "Properties": {}
    }
  ]
EOF

  service_role = aws_iam_role.iam_emr_service_role.arn
}