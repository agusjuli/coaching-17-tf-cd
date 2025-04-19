variable "prefix" {
  type        = string
  default     = "myapp"
  description = "Prefix for naming resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
  default     = ["subnet-04ae317c48a780c3c", "subnet-07f3764d1b416995b"]
}

variable "security_group_ids" {
  type        = list(string)
  description = "Security group IDs"
  default     = ["sg-0281eeb8b34431627"]
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}
