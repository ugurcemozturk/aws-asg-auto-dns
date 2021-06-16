
resource "aws_security_group" "this" {
  name        = var.service_name
  description = format("%s security group rules", var.service_name)
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description = format("Allow %s port", var.service_port)
    from_port   = var.service_port
    to_port     = var.service_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.service_name}-sg"
  }
}
