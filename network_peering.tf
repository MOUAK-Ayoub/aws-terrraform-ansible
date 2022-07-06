resource "aws_vpc_peering_connection" "master-worker" {
    provider = aws.region-master
    vpc_id = aws_vpc.aws_vpc_master.id
    peer_vpc_id = aws_vpc.aws_vpc_worker.id
    peer_region = aws_vpc.aws_vpc_worker
  
}

resource "aws_vpc_peering_connection_accepter" "worker-peer" {
    provider = aws.region-worker
    vpc_peering_connection_id = aws_vpc_peering_connection.master-worker.id
    
    auto_accept = true
  
}

resource "aws_route_table" "master-route" {
    provider = aws.region-master
    vpc_id = aws_vpc.aws_vpc_master.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_master.id

    }
    route {
        cidr_block = "192.168.1.0/24"
        vpc_peering_connection_id = aws_vpc_peering_connection.master-worker.id

    }
    lifecycle {
        ignore_changes=all
    }

    tags = {
        Name= "Route table of the master vpc"
    }
}

resource "aws_route_table" "worker-route" {
    provider = aws.region-worker
    vpc_id = aws_vpc.aws_vpc_worker
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw_worker.id

    }
    route {
        cidr_block = "10.0.1.0/24"
        vpc_peering_connection_id = aws_vpc_peering_connection_accepter.worker-peer.id

    }
    lifecycle {
        ignore_changes=all
    }
    
    tags = {
        Name= "Route table of the worker vpc"
    }
}

resource "aws_main_route_table_association" "vpc_route_asso_master" {
  provider = aws.region-master
  route_table_id = aws_route_table.master-route.id
  vpc_id = aws_vpc.aws_vpc_master.id

}

resource "aws_main_route_table_association" "vpc_route_asso_worker" {
  provider = aws.region-worker
  route_table_id = aws_route_table.worker-route.id
  vpc_id = aws_vpc.aws_vpc_worker.id

}