locals {
  prefix = var.prefix
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_ecr_repository" "ecr" {
  name         = "${local.prefix}-ecr"
  force_delete = true
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${local.prefix}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "~> 5.9.0"

  cluster_name = "${local.prefix}-ecs"

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 100
      }
    }
  }

  services = {
    YOUR-TASKDEFINITION-NAME = {
      cpu    = 512
      memory = 1024

      execution_role_arn = aws_iam_role.ecs_task_execution.arn

      container_definitions = {
        YOUR-CONTAINER-NAME = {
          essential = true
          image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${local.prefix}-ecr:latest"
          port_mappings = [
            {
              containerPort = 8080
              protocol      = "tcp"
            }
          ]
        }
      }

      assign_public_ip                    = true
      deployment_minimum_healthy_percent = 100
      subnet_ids                          = var.subnet_ids
      security_group_ids                  = var.security_group_ids
    }
  }
}
