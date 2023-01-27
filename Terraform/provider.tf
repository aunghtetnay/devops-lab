
provider "aws" {
  shared_credentials_files = ["$HOME/.aws/credentials"]
  region = var.region
}