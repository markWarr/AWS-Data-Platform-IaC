
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

To manually import the movielens data, run the following Lambda using the 'test' function: Import_MovieLens_Data_Lambda_Function

# References
See https://aws.amazon.com/emr/ for EMR docs.

https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/emr_cluster
for EMR cluster minimal configuration source. This implementation is updated for emr-5.35.0

If you find that the instance type is not supported in the chosen availability zone, see
https://docs.aws.amazon.com/emr/latest/ManagementGuide/emr-INSTANCE_TYPE_NOT_SUPPORTED-error.html

Pricing of EMR Instance types:
https://aws.amazon.com/emr/pricing/

Intro to EMR Studio
https://docs.aws.amazon.com/emr/latest/ManagementGuide/use-an-emr-studio.html

movielens data downloaded from here: http://files.grouplens.org/datasets/movielens/ml-100k.zip

# Troubleshooting
If an AWS nuke procedure clears out your sandbox but does not delete all resources, then you may end up with orphaned resources.

In this case, try 
terraform destroy

If this does not work, then delete the resource from the management console or the command line:

Instance profiles:
------------------
aws iam delete-instance-profile --instance-profile-name {InstanceProfileName} 


