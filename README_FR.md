# Infrastructure as Code (IaC) avec Terraform

Ce référentiel contient du code Terraform pour provisionner une infrastructure AWS simple pour un environnement de développement.

## Prérequis
- [Terraform](https://www.terraform.io/downloads.html) installé sur votre machine locale.
- Compte AWS avec les permissions appropriées.
- AWS CLI configuré avec une clé d'accès et une clé secrète.

## Utilisation
1. Clonez ce référentiel sur votre machine locale.
2. Naviguez jusqu'au répertoire du référentiel.
3. Exécutez `terraform init` pour initialiser le répertoire de travail.
4. Exécutez `terraform plan` pour voir le plan d'exécution.
5. Exécutez `terraform apply` pour appliquer les changements et provisionner l'infrastructure.

## Configuration
- `provider.tf`: Spécifie le fournisseur AWS et la région.
- `variables.tf`: Définit les variables d'entrée pour personnaliser les blocs CIDR des sous-réseaux et les zones de disponibilité.
- `main.tf`: Contient la configuration Terraform pour VPC, sous-réseaux, passerelle Internet, table de routage, groupes de sécurité, instance EC2 et instance RDS.
- `outputs.tf`: Définit les variables de sortie pour afficher des informations importantes après la provision.

## Composants de l'infrastructure
- **VPC**: Cloud privé virtuel avec un bloc CIDR de `10.0.0.0/16`.
- **Sous-réseaux**:
  - Sous-réseaux publics: `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`.
  - Sous-réseaux privés: `10.0.4.0/24`, `10.0.5.0/24`, `10.0.6.0/24`.
- **Passerelle Internet**: Attachée au VPC pour l'accès à Internet.
- **Table de routage**: Table de routage par défaut avec une route vers la passerelle Internet.
- **Groupes de sécurité**:
  - `instance_sg`: Groupe de sécurité pour l'instance EC2 autorisant le trafic entrant sur le port 80.
  - `db_sg`: Groupe de sécurité pour l'instance RDS autorisant le trafic entrant sur le port 5432.
- **Instance EC2**: Instance t2.micro avec Apache installé, servant une page web simple.
- **Instance RDS**: Instance de base de données PostgreSQL avec une configuration spécifiée.

## Sorties
- `instance_public_ip`: Adresse IP publique de l'instance EC2.
- `instance_private_ip`: Adresse IP privée de l'instance EC2.
- `db_instance_address`: Adresse de l'instance RDS.
- `db_instance_arn`: ARN de l'instance RDS.
- `db_instance_name`: Nom de l'instance RDS.
- `db_instance_endpoint`: Point de connexion de l'instance RDS.

## Auteur
##### @***a2b78***

N'hésitez pas à personnaliser et étendre cette infrastructure selon vos besoins.

