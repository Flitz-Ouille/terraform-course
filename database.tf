resource "docker_image" "mariadb" {
  name         = "mariadb:11"
  keep_locally = true
}

resource "docker_container" "db" {
  name  = "${var.project_name}-db-1"
  image = docker_image.mariadb.name

  networks_advanced {
    name = docker_network.main.name
  }

  env = [
    "MYSQL_ROOT_PASSWORD=${var.db_root_password}",
    "MYSQL_DATABASE=${var.db_name}",
    "MYSQL_USER=${var.db_user}",
    "MYSQL_PASSWORD=${var.db_password}",
  ]

  ports {
    internal = 3306
    external = 3306
  }
}

