output "load_balancer_url" {
  description = "URL d'accès au load balancer"
  value       = "http://192.168.20.133:${var.web_port}"
}

output "db_connection" {
  description = "Chaîne de connexion MariaDB"
  value       = "mysql -h 192.168.20.133 -P 3306 -u ${var.db_user} -p${var.db_password} ${var.db_name}"
}

output "docker_network_name" {
  value       = docker_network.main.name
  description = "Nom du réseau Docker principal"
}
