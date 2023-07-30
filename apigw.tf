resource "aws_api_gateway_rest_api" "ws_hello_time_api" {     #create api gateway
  name = "${var.my_name}-serverless-hello-time-api"
}
resource "aws_api_gateway_resource" "wengsiong_resource" {    #create a path /hello-time
  rest_api_id = aws_api_gateway_rest_api.ws_hello_time_api.id
  parent_id   = aws_api_gateway_rest_api.ws_hello_time_api.root_resource_id
  path_part  = "hello-time"
}
resource "aws_api_gateway_method" "ws_hello_time_method" {    #create a method called GET
  rest_api_id   = aws_api_gateway_rest_api.ws_hello_time_api.id
  resource_id   = aws_api_gateway_resource.wengsiong_resource.id
  http_method   = "GET"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "integration" {      #point to the lambda that created
  rest_api_id             = aws_api_gateway_rest_api.ws_hello_time_api.id
  resource_id             = aws_api_gateway_resource.wengsiong_resource.id
  http_method             = aws_api_gateway_method.ws_hello_time_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hello_time_lambda.invoke_arn
}
resource "aws_lambda_permission" "apigw_lambda" {       #give apigw permission to invoke the lambda
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello_time_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.ws_hello_time_api.execution_arn}/*/*"
}
resource "aws_api_gateway_deployment" "example" {   #deploy the lambda to a specific stage
  rest_api_id = aws_api_gateway_rest_api.ws_hello_time_api.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.ws_hello_time_api.body))
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [aws_api_gateway_method.ws_hello_time_method, aws_api_gateway_integration.integration]
}
resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.ws_hello_time_api.id
  stage_name    = "dev"
}