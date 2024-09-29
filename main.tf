resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = tls_private_key.rsa.public_key_openssh

}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "test" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "test-key"

  provisioner "local-exec" {
    command = "chmod 600 ${local_file.test.filename}"

  }


}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "test" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t2.micro"
  key_name      = "test"
  tags = {
    Name = "ec2"
  }


}

