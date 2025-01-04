terraform {

    backend s3 {

bucket = terraform-state-770

key = terraform/backend

region = us-east-1

}

}