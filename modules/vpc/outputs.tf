output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_was_subnet_ids" {
  value = aws_subnet.private_was[*].id
}

output "private_db_subnet_ids" {
  value = aws_subnet.private_db[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
