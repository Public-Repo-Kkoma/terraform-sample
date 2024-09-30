provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "terraform-sample"
    }
}

resource "aws_subnet" "first_subnet" {
    vpc_id = aws_vpc.main.id 
    cidr_block = "10.0.1.0/24"

    availability_zone = "ap-northeast-2a"

    tags = {
        Name = "sample-subnet-1"
    }
}

resource "aws_subnet" "second_subnet" {
    vpc_id = aws_vpc.main.id 
    cidr_block = "10.0.2.0/24"

    availability_zone = "ap-northeast-2b"

    tags = {
        Name = "sample-subnet-2"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id 

    tags = {
        Name = "sample-igw"
    }
}

resource "aws_route_table" "route_table" {
    vpc_id = aws_vpc.main.id 

    tags = {
        Name = "sample-route-table"
    }
}

resource "aws_route_table_association" "route_table_association_1" {
    subnet_id = aws_subnet.first_subnet.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "route_table_association_2" {
    subnet_id = aws_subnet.second_subnet.id
    route_table_id = aws_route_table.route_table.id
}

resource "aws_subnet" "private_first_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"

    availability_zone = "ap-northeast-2a"

    tags = {
        Name = "sample-private-subnet-1"
    }
}

resource "aws_subnet" "private_second_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"

    availability_zone = "ap-northeast-2b"

    tags = {
        Name = "sample-private-subnet-2"
    }
}

resource "aws_eip" "nat_1" {
    vpc = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_eip" "nat_2" {
    vpc = true

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_nat_gateway" "nat_gateway_1" {
    allocation_id = aws_eip.nat_1.id

    # private subnet이 아니라 public subnet을 연결해야 합니다.
    subnet_id = aws_subnet.first_subnet.id

    tags = {
        Name = "NAT-GW-1"
    }
}


resource "aws_nat_gateway" "nat_gateway_2" {
    allocation_id = aws_eip.nat_2.id

    subnet_id = aws_subnet.second_subnet.id

    tags = {
        Name = "NAT-GW-2"
    }
}

