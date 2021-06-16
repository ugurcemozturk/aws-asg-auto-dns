data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["default"]
  }
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.this.id
}
