terraform {
  backend "s3" {
    bucket = "sctp-ce2-tfstate-bkt"
    key = "wengsiong-serverless-app-time-temp.tfstate"
    region = "ap-southeast-1"
  }
}