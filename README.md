# AWS Terraform Setup for semi-distrubuted Wordpress infrastructure

Builds an infrastructure consisting of:
 - two web servers (Wordpress)
 - an Application Load Balancer for HTTP traffic
 - single MySQL DB
 - shared EFS storage between the Web servers

This is a educational project, so the credentials/ssh_keys are generated for every build

After Terraform reports, the build is up, it takes couple of minutes for the user-data script to bring up the WP

Used Hashicorp's [Learn Terraform Advanced Deployment Strategies](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments)
as a base for the project.


