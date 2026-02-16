output "vpn_connection_id" {
  value = aws_vpn_connection.this.id
}

output "vpn_tunnel1_address" {
  value = aws_vpn_connection.this.tunnel1_address
}

output "vpn_tunnel2_address" {
  value = aws_vpn_connection.this.tunnel2_address
}

output "customer_gateway_id" {
  value = aws_customer_gateway.this.id
}

output "vpn_gateway_id" {
  value = aws_vpn_gateway.this.id
}
