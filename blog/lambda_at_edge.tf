resource "aws_lambda_function" "pretty_url" {
  function_name = "pretty_url"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = aws_s3_bucket.lambda-functions-cloudfront.id
  s3_key    = "main.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "app.lambda_handler"
  runtime = "python3.7"

  role    = aws_iam_role.lambda_at_edge_exec.arn
  publish = true

  # We need the function in the "us-east-1" region
  provider = aws.virginia

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.pretty_url,
  ]

}

# This is manage the CloudWatch Log Group for the Lambda Function.
resource "aws_cloudwatch_log_group" "pretty_url" {
  name              = "/aws/lambda/us-east-1.pretty_url"
  retention_in_days = 14
}
