resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${each.key}"
  }
}

resource "aws_subnet" "eks_private" {
  for_each = var.eks_private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.env}-eks-private-${each.key}"
  }
}

resource "aws_subnet" "services_private" {
  for_each = var.services_private_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = {
    Name = "${var.env}-services-private-${each.key}"
  }
}

resource "aws_eip" "nat" {
  count = length(var.azs)
  vpc   = true
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(values(aws_subnet.public)[*].id, count.index)

  tags = {
    Name = "${var.env}-nat-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-public-rt"
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-private-rt-${count.index}"
  }
}

resource "aws_route" "nat_gateway_route" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway[count.index].id
}

resource "aws_route_table_association" "eks_private" {
  for_each = aws_subnet.eks_private

  subnet_id      = each.value.id
  route_table_id = element(aws_route_table.private[*].id, index(keys(aws_subnet.eks_private), each.key))
}

resource "aws_route_table_association" "services_private" {
  for_each = aws_subnet.services_private

  subnet_id      = each.value.id
  route_table_id = element(aws_route_table.private[*].id, index(keys(aws_subnet.services_private), each.key))
}
