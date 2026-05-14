# Projet Microservices E-commerce

Ce dépôt contient une mini-plateforme e-commerce basée sur des microservices Spring Boot, orchestrée avec Docker Compose.

## Contenu

- `eureka-server` : registre de services
- `api-gateway` : point d'entrée unique vers les API
- `produits-service` : gestion des produits et des catégories
- `avis-service` : gestion des avis produits
- `postgres` et `redis` : bases de données et cache

## Lancer le projet

1. Installer Docker et Docker Compose.
2. Depuis la racine du projet, lancer :

```bash
docker compose up --build
```

3. Ouvrir ensuite les services principaux :
- Eureka : http://localhost:8761
- API Gateway : http://localhost:8090
- Produits : http://localhost:8091
- Avis : http://localhost:8092

## Arrêter le projet

```bash
docker compose down
```

Pour supprimer aussi les données PostgreSQL :

```bash
docker compose down -v
```
