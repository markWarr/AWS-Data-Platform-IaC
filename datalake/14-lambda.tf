#http://files.grouplens.org/datasets/movielens/ml-1m.zip
# This lambda function takes the movielens dataset, unzips it and saves it to an s3 bucket.
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/lambda.zip"
function_name                  = "Import_MovieLens_Data_Lambda_Function"
role                           = aws_iam_role.lambda_role.arn
handler                        = "lambda.lambda_handler"
runtime                        = "python3.8"
timeout                        = 60
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
#todo configuration timeout to 30 secoinds