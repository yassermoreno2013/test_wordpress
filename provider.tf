provider "aws" {
  profile = "default"
  region  = "us-east-2"
}

#* In case you need to configure the connection instead of using AWS CLI configs
# provider "aws" {
#   region     = "us-east-2"
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
# }