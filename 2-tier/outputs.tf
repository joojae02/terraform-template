output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = "${aws_lb.external_alb.dns_name}"
}

output "db_connect_string" {
  description = "MyRDS database connection string"
  value       = "server=${aws_db_instance.my_db.address}; database=ExampleDB; Uid=${var.db_username}; Pwd=${var.db_password}"
  sensitive   = true
}