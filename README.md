# Terraform - Infrastructure locale Docker

> **Projet Terraform** réalisé dans le cadre du cours d'Infrastructure as Code.  
> Adaptation locale du déploiement GCP demandé, utilisant Docker comme provider pour simuler : réseau, compute, base de données et load balancer.

## 📋 Contexte

Le sujet initial demandait un déploiement sur Google Cloud Platform avec la structure suivante :
- Provider GCP avec région et project_id
- Réseau (VPC, subnets, NAT, firewall)
- Base de données Cloud SQL
- Instances Compute Engine avec autoscaling
- Load Balancer externe

**Adaptation réalisée** : Même logique et même structure de fichiers, mais avec le provider Docker pour un déploiement 100% local sur Debian.

## 🏗️ Architecture

┌─────────────────────────────────────────────┐
│ Load Balancer (Nginx) │
│ projet-docker-lucas-lb :80 │
└──────────────┬──────────────────────────────┘
│
┌───────┴────────┐
│ │
┌──────▼─────┐ ┌─────▼──────┐
│ tf-web-1 │ │ tf-web-2 │
│ (Nginx) │ │ (Nginx) │
│ :8080 │ │ │
└────────────┘ └────────────┘
│ │
└────────┬───────┘
│
┌──────────▼──────────────┐
│ Réseau tf-main-net │
└──────────┬──────────────┘
│
┌──────────▼──────────────┐
│ projet-docker-lucas-db-1│
│ (MariaDB :3306) │
└─────────────────────────┘


## 📁 Structure du projet

Respect strict de la structure demandée dans le sujet :

terraform-local/
├── scripts/
│ └── startup.sh # Script de provisioning (install Nginx + page HTML)
├── lb/
│ └── nginx.conf # Configuration du load balancer
├── provider.tf # Provider Docker (kreuzwerker/docker ~> 3.0)
├── apis.tf # Services/APIs (non utilisé en local)
├── network.tf # Réseau Docker "tf-main-net"
├── database.tf # Image + container MariaDB
├── storage.tf # Stockage (non utilisé actuellement)
├── compute.tf # Containers web Nginx (tf-web-1, tf-web-2)
├── load-balancer.tf # Container Nginx reverse proxy
├── variables.tf # Déclaration des variables
├── terraform.tfvars # Valeurs des variables (non commité, voir .example)
├── terraform.tfvars.example # Template des variables
├── outputs.tf # URL du LB + commande connexion DB
└── README.md # Ce fichier


## 🛠️ Prérequis

### Système
- Debian 12 (Trixie) ou équivalent
- Docker (`docker.io`) installé et fonctionnel
- Utilisateur ajouté au groupe `docker`

### Outils
- Terraform CLI >= 1.4.0
- Git (pour cloner le repo)

### Installation rapide

Installer Docker
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable --now docker
sudo usermod -aG docker $USER

Se déconnecter/reconnecter pour appliquer le groupe
Installer Terraform
wget -O- https://apt.releases.hashicorp.com/gpg |
sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg]
https://apt.releases.hashicorp.com $(lsb_release -cs) main" |
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install -y terraform

Vérifier
terraform version
docker ps

text

## 🚀 Déploiement

### 1. Cloner le repository

git clone https://github.com/Flitz-Ouille/terraform-course.git
cd terraform-course

text

### 2. Configurer les variables

cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

text

Modifier les valeurs selon vos besoins (mots de passe DB, nom du projet, ports).

### 3. Initialiser et déployer

terraform init
terraform plan
terraform apply

text

Valider avec `yes` quand Terraform demande confirmation.

### 4. Vérifier le déploiement

Lister les containers créés
docker ps

Outputs Terraform
terraform output

Tester le load balancer
curl http://localhost:80

Tester l'accès direct à web-1
curl http://localhost:8080

text

## 📊 Ressources créées

| Ressource | Nom | Description |
|-----------|-----|-------------|
| Network | `tf-main-net` | Réseau bridge Docker (équivalent VPC) |
| Container | `projet-docker-lucas-lb` | Load balancer Nginx (port 80) |
| Container | `tf-web-1` | Serveur web Nginx (port 8080 exposé) |
| Container | `tf-web-2` | Serveur web Nginx (backend uniquement) |
| Container | `projet-docker-lucas-db-1` | Base MariaDB 11 (port 3306) |
| Image | `nginx:latest` | Image Docker Nginx |
| Image | `mariadb:11` | Image Docker MariaDB |

## 🔧 Commandes utiles

Voir les ressources Terraform
terraform state list

Afficher les outputs
terraform output

Détruire l'infrastructure
terraform destroy

Voir les logs d'un container
docker logs projet-docker-lucas-lb
docker logs tf-web-1

Se connecter à la base de données
docker exec -it projet-docker-lucas-db-1 mysql -u produser -p

text

## 📖 Fichiers clés

### provider.tf
Définition du provider Docker avec socket Unix local.

### network.tf
Création du réseau Docker `tf-main-net` permettant la communication entre containers.

### compute.tf
Deux containers Nginx (`tf-web-1` et `tf-web-2`) attachés au réseau. Le premier expose le port 8080 pour test direct.

### database.tf
Container MariaDB configuré avec variables d'environnement pour :
- Base de données applicative
- Utilisateur applicatif
- Mots de passe (root + user)

### load-balancer.tf
Container Nginx configuré en reverse proxy, répartissant les requêtes HTTP entre `tf-web-1` et `tf-web-2` via la configuration `lb/nginx.conf`.

### variables.tf & terraform.tfvars
Paramétrage centralisé : nom du projet, ports, credentials DB.

### outputs.tf
- URL d'accès au load balancer
- Commande de connexion MySQL
- Nom du réseau Docker

## 🎯 Objectifs pédagogiques validés

✅ Structure de projet Terraform modulaire (fichiers séparés par fonction)  
✅ Utilisation de variables et fichiers `.tfvars`  
✅ Outputs pour récupérer les informations de déploiement  
✅ Provider configuration (Docker au lieu de GCP)  
✅ Réseau isolé pour les ressources  
✅ Compute distribué (plusieurs instances web)  
✅ Base de données avec variables d'environnement  
✅ Load balancer avec configuration custom  
✅ Script de startup (disponible dans `scripts/`)  

## 🔄 Équivalences GCP ↔ Docker

| Concept GCP | Équivalent Docker | Fichier |
|-------------|-------------------|---------|
| VPC | Docker Network | `network.tf` |
| Compute Engine | Container Nginx | `compute.tf` |
| Cloud SQL | Container MariaDB | `database.tf` |
| Cloud Load Balancing | Container Nginx (reverse proxy) | `load-balancer.tf` |
| Firewall rules | Ports exposés sur l'hôte | `*.tf` |
| Startup script | Script bash | `scripts/startup.sh` |

## 📝 Notes techniques

- **Provider Docker** : Utilisation du provider `kreuzwerker/docker` version ~> 3.0
- **Réseau** : Mode bridge avec DNS interne Docker pour la résolution de noms
- **Persistance DB** : Pas de volume Docker monté, données perdues au `destroy` (à améliorer pour la prod)
- **Load Balancing** : Round-robin simple via `upstream` Nginx
- **Variables sensibles** : Le fichier `terraform.tfvars` est dans `.gitignore` pour ne pas commiter les mots de passe

## 🚧 Améliorations possibles

- [ ] Ajouter un volume Docker pour persister les données MariaDB
- [ ] Créer une image custom avec `startup.sh` pour les containers web
- [ ] Implémenter `storage.tf` avec un volume ou bind-mount
- [ ] Ajouter un container Prometheus/Grafana pour le monitoring
- [ ] Health checks Terraform pour valider le déploiement
- [ ] Variables pour les versions d'images Docker

## 📚 Références

- [Terraform Docker Provider](https://registry.terraform.io/providers/kreuzwerker/docker/latest/docs)
- [Nginx Load Balancing](https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/)
- [MariaDB Docker](https://hub.docker.com/_/mariadb)
- [Terraform Best Practices](https://www.terraform-best-practices.com/)

## 👤 Auteur

**Lucas LESENS** (Flitz-Ouille)
Projet réalisé dans le cadre du cours Terraform - Décembre 2025
