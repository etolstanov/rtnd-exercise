# IAM role to attach to the lambda function

resource "aws_iam_role" "lambda_role" {
  name               = "iam_role_lambda_function"
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
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging

resource "aws_iam_policy" "lambda_logging" {
  name        = "iam_policy_lambda_logging_function"
  path        = "/"
  description = "IAM policy for logging"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

#IAM policy to allow reading ec2_resources (read-only)

resource "aws_iam_policy" "read_only_ec2_resources" {
  name        = "iam_policy_ec2_resources"
  path        = "/"
  description = "IAM policy for access ec2 resources"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "elasticloadbalancing:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:ListMetrics",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:Describe*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "autoscaling:Describe*",
            "Resource": "*"
        }
    ]
}
EOF
}

# Policy Attachments (logging and describe) ...

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

resource "aws_iam_role_policy_attachment" "policy_attach_ec2" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.read_only_ec2_resources.arn
}

# Generates an archive from content

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "${path.module}/lambda_src/"
  output_path = "${path.module}/zip/code.zip"
}

# Create the lambda function that counts running ec2 instances
# and groups them by instance_type

resource "aws_lambda_function" "lambdafunc" {
  filename      = "${path.module}/zip/code.zip"
  function_name = "count-running-ec2"
  role          = aws_iam_role.lambda_role.arn
  handler       = "count.lambda_handler"
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.policy_attach]
}
