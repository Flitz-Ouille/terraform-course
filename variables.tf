variable "project_name" {
  type        = string
  description = "Nom logique du projet"
  default     = "tf-local"
}

variable "web_port" {
  type        = number
  description = "Port HTTP publié sur l'hôte pour le LB"
  default     = 80
}

variable "db_root_password" {
  type        = string
  description = "Mot de passe root MariaDB"
  default     = "rootpass"
}

variable "db_name" {
  type        = string
  description = "Nom de la base applicative"
  default     = "appdb"
}

variable "db_user" {
  type        = string
  description = "Utilisateur applicatif"
  default     = "appuser"
}

variable "db_password" {
  type        = string
  description = "Mot de passe utilisateur applicatif"
  default     = "apppass"
}
