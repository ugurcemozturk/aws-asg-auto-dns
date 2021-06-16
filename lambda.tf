## DNS Registration lambda
data "archive_file" "register_zip" {
  type        = "zip"
  source_file = "./dns-management/register.py"
  output_path = "../dist/register.py"
}

resource "aws_lambda_function" "register" {
  filename      = "../dist/register.py"
  function_name = format("%s-dns-register", var.service_name)

  handler          = "register.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.dns_lambda.arn
  source_code_hash = data.archive_file.register_zip.output_base64sha256

  environment {
    variables = {
      HOSTED_ZONE_ID  = var.hosted_zone_id
      DNS_RECORD_NAME = var.dns_record_name
      TTL             = var.ttl
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.dns_register
  ]
}

## DNS Deregistration lambda
data "archive_file" "deregister_zip" {
  type        = "zip"
  source_file = "./dns-management/deregister.py"
  output_path = "../dist/deregister.py"
}

resource "aws_lambda_function" "deregister" {
  filename         = "../dist/deregister.py"
  function_name    = format("%s-dns-deregister", var.service_name)
  handler          = "deregister.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.dns_lambda.arn
  source_code_hash = data.archive_file.deregister_zip.output_base64sha256

  environment {
    variables = {
      HOSTED_ZONE_ID  = var.hosted_zone_id
      DNS_RECORD_NAME = var.dns_record_name
      TTL             = var.ttl
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.dns_deregister
  ]
}
