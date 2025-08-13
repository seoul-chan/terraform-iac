provider "aws" {
  region     = "ap-northeast-2"
  access_key = var.access_key_test
  secret_key = var.secret_key_test
}

variable access_key_test {
    type = string
    default = "xxxxx"
}
variable secret_key_test {
    type = string
    default = "xxxxx+"
}