terraform {

    backend s3 {

bucket = tf-status

key = terraform/backend

region = us-east-1

}

}