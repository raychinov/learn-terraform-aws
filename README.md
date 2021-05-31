# Learn Terraform & AWS

## AWS Terraform Setup for semi-distributed Wordpress infrastructure

### Builds an infrastructure consisting of:

- Two web servers (Wordpress)
- An Application Load Balancer for HTTP traffic
- Single MySQL DB
- Shared EFS storage between the Web servers
- Networking and security groups

### Prerequisite:

- AWS IAM user with security credentials  set (`~/.aws/credentials`)

- `aws cli` and `terraform` tools installed

### 

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



## Particularities:

- The Wordpress setup is done on the Web  server with id 0

- The output from the initializing script is in `/tmp/init.log`

- The DB optimizing cronjob runs in 2AM every Sunday, is placed in `/etc/crontab` and send the output to `/var/log/optimize.log`

- After Terraform reports, the build is up, it takes couple of minutes for the user-data script to bring up the Wordpress "Linux Namespaces" post

- The credentials and SSH key pairs are generated for every build. Pointers to to access credentials are given as output at the end of the run

- I used Hashicorp's [Learn Terraform Advanced Deployment Strategies](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments) as a base for the project.
