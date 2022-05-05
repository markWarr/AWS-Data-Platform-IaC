
# AWS-Data-Platform-IaC
Scripts to create a usable AWS Data Platform instance, preloaded with data. 

Make sure you run terraform destroy to tear down the installation when you have finished.

It will take some time to create the cluster but terraform will keep you updated every 10 seconds.

# Usage

First, install your AWS access keys into local environment variables.
For example, on MacOS:

export AWS_ACCESS_KEY_ID="*************"

export AWS_SECRET_ACCESS_KEY="************"

export AWS_SESSION_TOKEN="IQoJb3************"



Note - this will store state data locally so you will not be able to collaborate on your deployment. 
To collaborate, use a state data store such as terraform cloud or consul.

First, install Terraform locally. Then use the following commands:

terraform init

terraform plan -out config.tfplan

terraform apply config.tfplan

To tear down the infrastructure:

terraform destroy


# References
See https://aws.amazon.com/emr/ for EMR docs.

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_cluster
for EMR cluster minimal configuration source. This implementation is updated for emr-5.35.0

If you find that the instance type is not supported in the chosen availability zone, see
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-INSTANCE_TYPE_NOT_SUPPORTED-error.html

Pricing of EMR Instance types:
https://aws.amazon.com/emr/pricing/
