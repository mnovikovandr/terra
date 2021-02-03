variable "name" {
	default = "misha"
}

variable "location" {
  default = "westus"
}

variable "tags" {
  type = map

  default = {
    "Environment" = "Terraform GS"
  }
}