variable "instance_name_public" {
    description = "Value of the name tag of my EC2 instance"
    type        = string
    default     = "MyPublicInstance"
}

variable "instance_name_private" {
    description = "Value o f the name tag of my EC2 instance"
    type        = string
    default     = "MyPrivateInstance"
}

variable "instance_type" {
    description = "Type of EC2 instance to launch"
    type        = string
    default     = "t2.micro"
}

# variable "vertical_slice_vpc" {
#     description = "The VPC ID where resources will be deployed"
#     type        = string
#     default     = "vpc-0bb1c79de3EXAMPLE"
# }

variable "app_port" {
    default     = 5000
}

variable "my_ip" {
    description = "Your IP address with /32 suffix"
    type        = string
}

variable "key_pair_name" {
    description = "The name of the existing key pair to use for EC2 instances"
    type        = string
}