data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}


resource "aws_vpc" "aws_vpc_master" {

  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc_master_jenkins"
  }

}

resource "aws_vpc" "aws_vpc_worker" {

  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "vpc_worker_jenkins"
  }

}

resource "aws_internet_gateway" "igw_master" {
  provider = aws.region-master
  vpc_id   = aws_vpc.aws_vpc_master.id
}

resource "aws_internet_gateway" "igw_worker" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.aws_vpc_worker.id
}

resource "aws_subnet" "subnet_master_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.aws_vpc_master.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_master_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.aws_vpc_master.id
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "subnet_worker_1" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.aws_vpc_worker.id
  cidr_block = "192.168.1.0/24"
}

