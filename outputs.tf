output "ecr_repository_name" {
  value       = aws_ecr_repository.ecr.name
  description = "ECR repository name"
}

output "ecr_repository_url" {
  value       = aws_ecr_repository.ecr.repository_url
  description = "ECR repository URL"
}

output "ecs_cluster_name" {
  value       = module.ecs.cluster_name
  description = "ECS cluster name"
}

output "task_definition_name" {
  value       = "YOUR-TASKDEFINITION-NAME"
  description = "ECS task definition name"
}

output "ecs_service_name" {
  value       = "YOUR-TASKDEFINITION-NAME"
  description = "ECS service name"
}

output "container_name" {
  value       = "YOUR-CONTAINER-NAME"
  description = "Container name"
}
