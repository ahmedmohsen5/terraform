terraform {

    backend s3 {

        bucket = "tf-status"

        key = "terraform"       
}

}

provider "aws" {
  region = var.AWS_REGION
}

