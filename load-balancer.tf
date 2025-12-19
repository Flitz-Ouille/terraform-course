resource "docker_container" "lb" {
  name  = "${var.project_name}-lb"
  image = docker_image.nginx.name

  networks_advanced {
    name = docker_network.main.name
  }

  mounts {
    target    = "/etc/nginx/nginx.conf"
    source    = "/home/lucas/terraform-local/lb/nginx.conf"
    type      = "bind"
    read_only = true
  }

  ports {
    internal = 80
    external = var.web_port
  }
}

