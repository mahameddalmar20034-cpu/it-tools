resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]


}

resource "aws_iam_role" "github_actions" {
  name = "it-tools-github-actions-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:sub" : "repo:mahameddalmar20034-cpu/it-tools:ref:refs/heads/main",

            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
        }
      }
    ]



  })

  tags = {
  Name = "it-tools-github-actions-role" }
}



resource "aws_iam_policy" "github-actions" {
  name        = "github-actions_policy"
  path        = "/"
  description = "What policy the workflow will assume"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {

        Action = [
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Effect   = "Allow"
        Resource = var.repository_arn
      },

      { Effect = "Allow"
        Action = ["ecs:UpdateService", "ecs:DescribeServices"]

        Resource = var.service_arn

      },
    ]





  })
}


resource "aws_iam_role_policy_attachment" "it-tools" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github-actions.arn
}



