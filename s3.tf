resource "aws_s3_bucket" "b" {
  bucket = "my-tf-test-bucket-sumesh"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
