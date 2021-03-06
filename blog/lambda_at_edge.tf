# This lambda function does not have any log permission as I do not want to deal with the GDPR.
# The IP address is a sensitive data and I do not want to record it even by mistake.
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

}