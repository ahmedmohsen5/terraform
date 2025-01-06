# Required variables for AWS credentials
variable "aws_access_key_id" {
description = "AWS Access Key ID"
type        = string
sensitive   = true
}

variable "aws_secret_access_key" {
description = "AWS Secret Access Key"
type        = string
sensitive   = true
}

variable "AWS_REGION" {
description = "AWS Region"
type        = string
}

# Configure the AWS Provider
provider "aws" {
access_key = var.aws_access_key_id
secret_key = var.aws_secret_access_key
region     = var.AWS_REGION
}

# Configure the backend
terraform {
backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
}
}

