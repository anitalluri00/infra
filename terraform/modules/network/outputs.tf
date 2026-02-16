output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "dmz_subnet_ids" {
  description = "DMZ subnet IDs"
  value       = [for subnet in aws_subnet.dmz : subnet.id]
}

output "private_app_subnet_ids" {
  description = "Private app subnet IDs"
  value       = [for subnet in aws_subnet.app : subnet.id]
}

output "private_data_subnet_ids" {
  description = "Private data subnet IDs"
  value       = [for subnet in aws_subnet.data : subnet.id]
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.this.cidr_block
}

output "app_route_table_ids" {
  description = "Route table IDs for app subnets"
  value       = [for rt in aws_route_table.app : rt.id]
}

output "data_route_table_ids" {
  description = "Route table IDs for data subnets"
  value       = [for rt in aws_route_table.data : rt.id]
}
