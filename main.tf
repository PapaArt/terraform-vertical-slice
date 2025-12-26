provider "aws" {
    profile = "default"
    region = "us-east-1"
}

resource "aws_vpc" "vertical_slice_vpc" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true
    tags = {
        Name = "VerticalSliceVPC"
    }
}

resource "aws_subnet" "public_vertical_subnet" {
    vpc_id            = aws_vpc.vertical_slice_vpc.id
    cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicVerticalSubnet"
    }
}

resource "aws_subnet" "private_vertical_subnet" {
    vpc_id            = aws_vpc.vertical_slice_vpc.id
    cidr_block        = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "PrivateVerticalSubnet"
    }
}

resource "aws_internet_gateway" "vertical_slice_igw" {
    vpc_id = aws_vpc.vertical_slice_vpc.id
    tags = {
        Name = "VerticalSliceIGW"
    }
}

resource "aws_eip" "vertical_slice_eip" {
    domain = "vpc"
    tags = {
        Name = "VerticalSliceEIP"
    }
}

resource "aws_nat_gateway" "vertical_slice_nat_gw" {
    allocation_id = aws_eip.vertical_slice_eip.id
    subnet_id     = aws_subnet.public_vertical_subnet.id
    tags = {
        Name = "VerticalSliceNATGW"
    }
}

resource "aws_route_table" "public_vertical_route_table" {
    vpc_id = aws_vpc.vertical_slice_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.vertical_slice_igw.id
    }

    route {
       cidr_block = "10.0.0.0/16"
       gateway_id = "local"
    }

    tags = {
        Name = "PublicVerticalRouteTable"
    }
}

resource "aws_route_table_association" "public_rta" {
    subnet_id      = aws_subnet.public_vertical_subnet.id
    route_table_id = aws_route_table.public_vertical_route_table.id
}

resource "aws_route_table" "private_vertical_route_table" {
    vpc_id = aws_vpc.vertical_slice_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.vertical_slice_nat_gw.id
    }

    route {
        cidr_block = "10.0.0.0/16"
        gateway_id = "local"
    }

    tags = {
        Name = "PrivateVerticalRouteTable"
    }
}

resource "aws_route_table_association" "private_rta" {
    subnet_id      = aws_subnet.private_vertical_subnet.id
    route_table_id = aws_route_table.private_vertical_route_table.id
}