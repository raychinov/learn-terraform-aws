resource "tls_private_key" "bluekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "bluekey-pair"
  public_key = tls_private_key.bluekey.public_key_openssh
}


