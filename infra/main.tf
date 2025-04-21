provider "aws" {
    region = "af-south-1"
}

terraform {
    backend "s3" {
        bucket         = "games-terraform-state-bucket"
        key            = "terraform/state"
        region         = "af-south-1"
        encrypt        = false
    }
}


resource "aws_apigatewayv2_api" "test_api_gateway" {
    name        = "games-api-gateway"
    description = "API Gateway for games microservices"
    protocol_type = "HTTP"

    tags = {
        Name = "games-api-gateway"
    }
}

resource "aws_lambda_function" "test_lambda" {
    function_name = "games-lambda-function"
    handler = "index.handler"
    runtime = "python3.11"
    role = aws_iam_role.lambda_execution_role.arn
    
    tags = {
        Name = "games-lambda-function"
    }
  
}
resource "aws_apigatewayv2_integration" "test_integration" {
    api_id = aws_apigatewayv2_api.test_api_gateway.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.test_lambda.invoke_arn
    payload_format_version = "2.0"

    depends_on = [aws_lambda_function.test_lambda]
}

resource "aws_apigatewayv2_route" "test_route" {
    api_id = aws_apigatewayv2_api.api_gateway.id
    route_key = "GET /games"
    target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}