variable "name" {
  type = string
	default = "misha"
}

variable "location" {
  type = string
  default = "westeurope"
}

variable "tags" {
  type = map

  default = {
    "Environment" = "Terraform GS"
  }
}