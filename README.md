
# AWS-Data-Platform-IaC
Scripts to create a usable AWS Data Platform instance, preloaded with data. 

Make sure you run terraform destroy to tear down the installation when you have finished.

It will take > 8 mins to create the cluster but terraform will keep the progress updated every 10 seconds in your shell.

These scripts will do the following using the hashicorp/aws AWS provider:
- Create a VPC
- Create subnet within the VPC including necessary security groups, roles, role policies  and role profiles.
- Create an S3 bucket for storing EMR logs
- Create an S3 bucket for EMR data
- Create an EMR Cluster with Spark and Jupyter Enterprise Gateway applications
- Create an EMR Studio instance with a connection to the EMR data S3 bucket
- Create a Lambda function to import the MovieLens data, using the source in the pyton folder.
- Run the Lambda function by using a Terraform output that quereies the output of the installed Lambda function.



# Usage

First, install your AWS access keys into local environment variables.
For example, on MacOS:

```
export AWS_ACCESS_KEY_ID="*************"
export AWS_SECRET_ACCESS_KEY="************"
export AWS_SESSION_TOKEN="IQoJb3************"
```

Note - this will store state data locally so you will not be able to collaborate on your deployment. 
To collaborate, use a state data store such as terraform cloud or consul.

First, install Terraform locally. Then use the following commands:

```
terraform init

terraform plan -out config.tfplan

terraform apply config.tfplan
```

To tear down the infrastructure:

```
terraform destroy
```

Once installed, check that the resources have been instatiated correctly:
Check that the emr-studio-bucket-mt S3 Bucket contains the Movielens data.
In EMR, check that the EMR cluster has been created and is in the state "waiting - cluster ready"
Create a notebook in EMR and link it to the created cluster
Check that the notebook can be opened on JupyterLab.

If you wish to manually import the movielens data, run the following Lambda using the 'test' function: 
```
Import_MovieLens_Data_Lambda_Function
```

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
If an AWS nuke procedure clears out your sandbox but does not delete all resources, then you may be left with orphaned resources.

In this case, try 
terraform destroy

If this does not work, then delete the resource from the management console or the command line:

Instance profiles:
------------------
aws iam delete-instance-profile --instance-profile-name {InstanceProfileName} 


