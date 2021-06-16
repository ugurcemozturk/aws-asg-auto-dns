# Role for lambda executions
resource "aws_iam_role" "dns_lambda" {
  name = "dns_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": "AssumesTheRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "dns_lambda_policy" {
  role       = aws_iam_role.dns_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" // TODO: Ooops, Admin role must be replaced
}


# Role for SNS trigger
resource "aws_iam_role" "sns_role" {
  name = "sns_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com","autoscaling.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": "AssumesTheRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "sns_policy" {
  role       = aws_iam_role.sns_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess" // TODO: Ooops, Admin role must be replaced
}
