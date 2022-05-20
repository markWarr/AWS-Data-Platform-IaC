// This file contains all of the required inputs for this module
variable "environment" {
  description = "The type of environment being deployed."
  type        = string
  default     = "Development"

  validation {
    condition     = contains(["Development", "Staging", "Production", "Management"], var.environment)
    error_message = "The Environment input variable must be one of Development, Staging, Production, or Management."
  }
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "us-east-1"
}

variable "EMR_instance_type"{
  type        = string
  description = "EMR Instance Type"
  default     = "m4.large"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in VPC"
  default     = true
}

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "168.31.0.0/16"
}

variable "vpc_subnet1_cidr_block" {
  type        = string
  description = "CIDR Block for Subnet 1 in VPC"
  default     = "168.31.0.0/20"
}

variable "s3_emr_studio_name" {
  type        = string
  description = "Name of s3 bucket for emr studio"
  default     = "emr-studio-bucket-mt"
}