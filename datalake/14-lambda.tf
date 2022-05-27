# zips the python file in order to be used by lambda
data "archive_file" "lf_settings_1_zip" {
  type        = "zip"
  source_dir  = "${path.module}/scripts/python/"
  output_path = "${path.module}/scripts/lambda.zip"
}


# This lambda function takes the movielens dataset, unzips it and saves it to an s3 bucket.
# Timeout set to 60 seconds - default is 3s.
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/lambda.zip"
function_name                  = "Import_MovieLens_Data_Lambda_Function"
role                           = aws_iam_role.lambda_role.arn
handler                        = "lambda.lambda_handler"
runtime                        = "python3.8"
timeout                        = 60
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

data "aws_lambda_invocation" "data_import_lambda_invocation" {
  function_name = aws_lambda_function.terraform_lambda_func.function_name

  input = ""
  depends_on = [
    aws_lambda_function.terraform_lambda_func,
  ]  


}

  output "lambda_message" {
    value = jsondecode(data.aws_lambda_invocation.data_import_lambda_invocation.result)["message"]
  }