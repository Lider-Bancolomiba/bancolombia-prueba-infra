variable "env" {
  type        = string
  description = "environment"
}

variable "micro_usuarios" {
  description = "values for microservice usuarios"
  type = object({
    name               = string
    cpu                = number
    memory             = number
    task_containerPort = number
    task_hostPort      = number
    task_protocol      = string
    app_image          = string
  })

}