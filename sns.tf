# SNS topic for instance creation lifecyclehook
resource "aws_sns_topic" "dns_register_topic" {
  name = "dns_register_topic"
  //TODO: Move this to /assets/deliver_policy.json as a file instead of an inline policy.
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  depends_on = [
    aws_lambda_function.register
  ]
}

# SNS topic for instance termination lifecyclehook
resource "aws_sns_topic" "dns_deregister_topic" {
  name = "dns_deregister_topic"
  //TODO: Move this to /assets/deliver_policy.json as a file instead of an inline policy.
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
  depends_on = [
    aws_lambda_function.deregister
  ]
}

# DNS registration SNS - Lambda subscription
resource "aws_sns_topic_subscription" "sns_register_lambda_subscription" {
  topic_arn = aws_sns_topic.dns_register_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.register.arn

  depends_on = [
    aws_lambda_function.register,
    aws_sns_topic.dns_register_topic
  ]
}

# DNS deregistration SNS - Lambda subscription
resource "aws_sns_topic_subscription" "sns_deregister_lambda_subscription" {
  topic_arn = aws_sns_topic.dns_deregister_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.deregister.arn

  depends_on = [
    aws_lambda_function.deregister,
    aws_sns_topic.dns_deregister_topic
  ]
}
