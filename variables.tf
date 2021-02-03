variable "name" {
  type = string
	default = "misha"
}

variable "location" {
  type = string
  default = "westus"
}

variable "tags" {
  type = map

  default = {
    "Environment" = "Terraform GS"
  }
}