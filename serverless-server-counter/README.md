# About
The purpose of this project is to deploy an AWS Lambda Function with Terraform. This function prints all running instances grouped by "instance_type" and the cardinality in JSON.

# Deploying the stack
In order to deploy the function, we will use the terraform cli. First, we need to initialize the directory:

$ **terraform init**

Then, we ask terraform to show us what is going to create/update/delete:

$ **terraform plan**

Finally, we apply the stack:

$ **terraform apply**

# Invoking the function
Assuming that you have a Linux terminal already configured with the awscli and the terraform stack deployed successfully, we need to execute the following command:

$ **aws lambda invoke --function-name count-running-ec2 --cli-binary-format raw-in-base64-out response.json** \
$ cat response.json \
"[{\"type\": \"t2.nano\", \"count\": 1}]"
