/* resource "aws_vpc_peering_connection" "vpc_cds_peering" {
  vpc_id        = module.vpc.vpc_id # requester
  peer_owner_id = var.peer_owner_id # accepter owner id
  peer_vpc_id   = var.vpc_remote_id # accepter
  auto_accept   = false
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
} */

/* data "aws_vpc" "accepter" {
  id = var.vpc_remote_id
}

data "aws_route_tables" "accepter" {
  vpc_id = var.vpc_remote_id
}

data "aws_vpc" "requester" {
  id = module.vpc.vpc_id

}

data "aws_route_tables" "requester" {
  vpc_id = module.vpc.vpc_id
}


resource "aws_route" "requester" {
  count                     = length(local.requester_route_tables_ids)
  route_table_id            = local.requester_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.accepter.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_cds_peering.id
}

resource "aws_route" "accepter" {
  count                     = length(local.accepter_route_tables_ids)
  route_table_id            = local.accepter_route_tables_ids[count.index]
  destination_cidr_block    = data.aws_vpc.requester.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_cds_peering.id
} */
