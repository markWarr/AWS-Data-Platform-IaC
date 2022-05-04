See

https://aws.amazon.com/emr/

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_cluster
for EMR cluster minimal configuration source. This implementation is updated for emr-5.35.0

If you find that the instance type is not supported in the chosen availability zone, see
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-INSTANCE_TYPE_NOT_SUPPORTED-error.html

Pricing of EMR Instance types:
https://aws.amazon.com/emr/pricing/


Make sure you run Terraform Destroy when you're finished or you'll be leaving the destruction to the Sandbox Friday tear down routine.

It will take some time to create the cluster but terraform will keep you updated every 10 seconds.

Usage:

First, install your AWS access keys into local environment variables.
For example, on MacOS:

export AWS_ACCESS_KEY_ID="ASIATZUPEIUG*****"
export AWS_SECRET_ACCESS_KEY="gYydL2QbFVt7VQr************"
export AWS_SESSION_TOKEN="IQoJb3************"



Note - this will store state data locally so you will not be able to collaborate on your deployment. 
To collaborate, use a state data store such as terraform cloud or consul.

Terraform init

terraform plan -out config.tfplan

terraform apply config.tfplan

terraform destroy