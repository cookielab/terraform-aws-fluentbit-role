resource "aws_iam_policy" "aws_cluster_fluentbit" {
  name        = var.policy_name
  path        = "/"
  description = "Allows access to resources needed to run kubernetes cluster fluentbit."

  policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutLogEvents",
        "logs:PutRetentionPolicy"
      ],
      "Resource": "*"
    }
  ]
}
JSON
}

resource "aws_iam_role" "aws_cluster_fluentbit" {
  count = var.ec2_role_name == null ? 1 : 0

  name = var.role_name
  path = "/"

  assume_role_policy = <<JSON
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Effect": "Allow",
      "Principal": {
        "Federated": "${var.oidc_assume_role_arn}"
      }
    }
  ]
}
JSON
}

resource "aws_iam_role_policy_attachment" "aws_cluster_fluentbit" {
  policy_arn = aws_iam_policy.aws_cluster_fluentbit.arn
  role       = var.ec2_role_name == null ? aws_iam_role.aws_cluster_fluentbit[0].name : var.ec2_role_name
}
