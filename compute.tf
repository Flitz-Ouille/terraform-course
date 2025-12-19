resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = true
}

resource "docker_container" "web" {
  name  = "tf-web-1"
  image = docker_image.nginx.name

  networks_advanced {
    name = docker_network.main.name
  }

  ports {
    internal = 80
    external = 8080
  }
}

resource "docker_container" "web2" {
  name  = "tf-web-2"
  image = docker_image.nginx.name

  networks_advanced {
    name = docker_network.main.name
  }
}
