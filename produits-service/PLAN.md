# Plan d'implémentation — produits-service

## Objectif
Implémenter la Partie 1 du sujet : microservice `produits-service` (port 8091) avec Spring Boot 4, PostgreSQL, Redis cache, documentation OpenAPI, et données initiales.

## Structure proposée

- `src/main/java/.../entity` : `Categorie`, `Produit`
- `src/main/java/.../repository` : `CategorieRepository`, `ProduitRepository`
- `src/main/java/.../service` : `ProduitService`, `CategorieService`
- `src/main/java/.../controller` : `ProduitController`, `CategorieController`
- `src/main/resources` : `application.yml`, `data.sql`
- `Dockerfile`, `pom.xml`, `README.md`

## Étapes (rapide)

1. Initialiser le projet Spring Boot (Maven, JDK 25) : `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `lombok`, `spring-boot-starter-cache`, `spring-boot-starter-data-redis`, `springdoc-openapi-starter-webmvc-ui`, `postgresql`.
2. Créer les entités JPA : `Categorie` (id, nom) et `Produit` (id, nom, prix, stock, categorie @ManyToOne).
3. Créer les repositories JPA pour `Categorie` et `Produit`.
4. Implémenter la couche service (`ProduitService`) contenant la logique métier (filtres par catégorie, création produit, invalidation cache).
5. Implémenter les controllers REST exposant les endpoints listés dans l'énoncé.
6. Ajouter `data.sql` pour insérer 3 catégories et 5 produits au démarrage.
7. Configurer Redis : activer `@EnableCaching`, ajouter `@Cacheable` sur la méthode GET liste produits et `@CacheEvict` sur la création (POST).
8. Ajouter configuration Springdoc OpenAPI pour exposer Swagger UI (endpoint `/swagger-ui.html`).
9. Ajouter `Dockerfile` (JAR + JDK 25) et notar dépendances Docker (postgres, redis, eureka) dans `docker-compose.yml` racine.
10. Écrire tests :
   - Test unitaire pour `ProduitService` avec Mockito.
   - Test d'intégration pour `ProduitRepository` avec `@DataJpaTest` (H2 ou Testcontainers).
11. Rédiger `README.md` avec commandes pour build/run (mvn, docker-compose).

## Config quick-notes

- Port application : `8091`
- `application.yml` profils : `spring.datasource` vers Postgres (Docker), Redis config, `spring.cache.type=redis`.
- `data.sql` : `INSERT INTO categorie (...)`, `INSERT INTO produit (...)`.
- Cache key strategy : cache name `produits::all` or param-aware caching when `categorieId` present.

## Commandes utiles

```bash
# Générer projet (exemple CLI)
curl https://start.spring.io/starter.tgz -d dependencies=web,data-jpa,lombok,cache,redis,postgresql -d javaVersion=25 -d bootVersion=4.0.0 -d type=maven-project | tar -xz

# Build
mvn -DskipTests package

# Docker (local compose from repo root)
docker compose up --build
```

## Critères d'acceptation (Partie 1)

- Tous les endpoints listés fonctionnels via API Gateway later.
- GET `/api/produits` utilisera Redis cache; POST invalidation.
- Swagger UI accessible.
- `data.sql` charge 3 catégories + 5 produits au démarrage.

---
Date: 2026-05-12
