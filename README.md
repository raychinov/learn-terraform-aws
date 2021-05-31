# Learn Terraform & AWS

## AWS Terraform Setup for semi-distributed Wordpress infrastructure

### Builds an infrastructure consisting of:

- two web servers (Wordpress)
- an Application Load Balancer for HTTP traffic
- single MySQL DB
- shared EFS storage between the Web servers
- Networking and security groups



### Prerequisite:

 AWS IAM user with security credentials  set (`~/.aws/credentials`)

### Provisioning:

```bash
cd ~
git clone https://github.com/raychinov/learn-terraform-aws.git
cd learn-terraform-aws
terraform init
## The one command to bring up the infrastructure
terraform apply -auto-approve
```



### Destroying the Infrastructure:

```bash
cd ~/learn-terraform-aws
## The one command to bring it down
terraform destroy -auto-approve
```

This is a educational project, so the credentials/ssh_keys are generated for every build. Pointers to to access credentials are given as output at the end of the run.

After Terraform reports, the build is up, it takes couple of minutes for the user-data script to bring up the Wordpress "Namespaces" post

Used Hashicorp's [Learn Terraform Advanced Deployment Strategies](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments) as a base for the project.


























































