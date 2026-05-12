# Plan d’implémentation — avis-service

## Objectif
Implémenter la Partie 2 du sujet : microservice `avis-service` (port 8092) avec Spring Boot 4, PostgreSQL dédié, architecture en couches, Swagger, et vérification de l’existence du produit via Feign.

## Structure proposée

- `src/main/java/.../entity` : `Avis`
- `src/main/java/.../repository` : `AvisRepository`
- `src/main/java/.../service` : `AvisService`
- `src/main/java/.../controller` : `AvisController`
- `src/main/java/.../dto` : `AvisRequest`, `AvisResponse`
- `src/main/java/.../client` : client Feign vers `produits-service`
- `src/main/resources` : `application.yml`
- `Dockerfile`, `pom.xml`, `README.md`

## Étapes (rapide)

1. Initialiser le projet Spring Boot 4 (Maven, JDK 25) avec `spring-boot-starter-web`, `spring-boot-starter-data-jpa`, `spring-boot-starter-validation`, `lombok`, `postgresql`, `springdoc-openapi-starter-webmvc-ui`, et le support Feign.
2. Créer l’entité JPA `Avis` avec les champs `id`, `produitId`, `auteur`, `commentaire`, `note`.
3. Créer `AvisRepository extends JpaRepository<Avis, Long>`.
4. Implémenter `AvisService` pour gérer la consultation et la création des avis.
5. Déclarer un `@FeignClient(name = "produits-service")` pour vérifier qu’un produit existe avant l’enregistrement d’un avis.
6. Retourner une erreur HTTP 404 si le produit est introuvable.
7. Exposer les endpoints REST demandés : `GET /api/avis/{produitId}` et `POST /api/avis`.
8. Ajouter la documentation Swagger accessible sur `/swagger-ui.html`.
9. Configurer `application.yml` avec le port `8092` et la connexion à la base PostgreSQL dédiée.
10. Ajouter un `Dockerfile` pour le service.

## Config quick-notes

- Port application : `8092`
- Base de données : PostgreSQL séparée pour `avis-service`
- `note` doit rester entre `1` et `5`
- L’appel Feign sert uniquement à valider l’existence du produit avant création

## Critères d’acceptation (Partie 2)

- `GET /api/avis/{produitId}` retourne les avis du produit demandé.
- `POST /api/avis` refuse la création si le produit est inconnu.
- Swagger UI est accessible.
- Le service reste structuré en couches comme `produits-service`.
