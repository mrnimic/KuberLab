variable "ssh-source-ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
