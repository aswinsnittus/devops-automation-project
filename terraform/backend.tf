terraform {
  backend "s3" {
    bucket         = "devops-tfstate-aswinsnittu-20251031112102"
    key            = "devops-project/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "devops-tf-locks-aswinsnittu-20251031112102"
    encrypt        = true
  }
}
