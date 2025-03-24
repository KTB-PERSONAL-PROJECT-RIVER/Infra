output "alb_dns" {
  value = aws_lb.alb.dns_name
}

output "was_sg_id" {
  value = aws_security_group.was_sg.id
}

output "target_group" {
  value = aws_lb_target_group.tg
}

output "target_group_arn" {
  value = aws_lb_target_group.tg.arn
}
