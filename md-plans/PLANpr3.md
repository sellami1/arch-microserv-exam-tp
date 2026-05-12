# Plan d'implémentation — Partie 3 Infrastructure (Eureka · Feign · API Gateway)

## Objectif
Implémenter l'infrastructure de microservices de la Partie 3 : serveur Eureka (port 8761), client Feign pour la vérification des produits dans avis-service, et API Gateway (port 8090) pour le routage centralisé.

## Structure proposée

### Eureka Server
- `src/main/java/.../EurekaServerApplication.java` avec `@EnableEurekaServer`
- `src/main/resources/application.yml`
- `Dockerfile`, `pom.xml`, `README.md`

### Feign Client dans avis-service
- `src/main/java/.../client/ProduitClient.java` (interface `@FeignClient`)
- Configuration pour activer Feign dans avis-service

### API Gateway
- `src/main/java/.../ApiGatewayApplication.java` avec `@SpringBootApplication`
- Configuration des routes Spring Cloud Gateway
- `src/main/resources/application.yml`
- `Dockerfile`, `pom.xml`, `README.md`

## Étapes d'implémentation

### Eureka Server

1. Créer un projet Spring Boot 4 (Maven, JDK 25) avec `spring-boot-starter-web`, `spring-cloud-starter-netflix-eureka-server`.
2. Ajouter l'annotation `@EnableEurekaServer` sur la classe principale.
3. Configurer `application.yml` avec le port `8761` et les propriétés Eureka.
4. Ajouter un `Dockerfile` pour l'image du service.

### Feign Client dans avis-service

1. Ajouter la dépendance `spring-cloud-starter-openfeign` dans le `pom.xml` d'avis-service.
2. Activer Feign avec `@EnableFeignClients` sur la classe principale d'avis-service.
3. Créer une interface `ProduitClient` annotée avec `@FeignClient(name = "produits-service")`.
4. Déclarer une méthode `getProduitById(Long id)` pour appeler `GET /api/produits/{id}`.
5. Utiliser ce client dans `AvisService` pour valider l'existence du produit avant enregistrement.
6. Gérer la réponse Feign (lever une `ResourceNotFoundException` en cas d'erreur 404).

### API Gateway

1. Créer un projet Spring Boot 4 (Maven, JDK 25) avec `spring-cloud-starter-gateway`, `spring-cloud-starter-netflix-eureka-client`.
2. Configurer les routes dans `application.yml` :
   - `/api/produits/**` → lb://produits-service
   - `/api/categories/**` → lb://produits-service
   - `/api/avis/**` → avis-service
3. Activer la découverte de services via Eureka (LoadBalancer client).
4. Enregistrer l'API Gateway auprès d'Eureka avec `spring.application.name=api-gateway` (port 8090).
5. Ajouter un `Dockerfile` pour l'image du service.

## Config quick-notes

### Eureka Server
- Port : `8761`
- `eureka.server.enable-self-preservation: false` (pour le mode dev)
- `eureka.client.register-with-eureka: false`
- `eureka.client.fetch-registry: false`

### Feign Client
- Dépendance : `spring-cloud-starter-openfeign`
- Annotation classe principale : `@EnableFeignClients`
- URL de base déduite depuis Eureka via le nom d'application

### API Gateway
- Port : `8090`
- Route format : `spring.cloud.gateway.routes[0].id`, `.predicates`, `.uri`
- LoadBalancer scheme : `lb://` pour la découverte via Eureka

## Critères d'acceptation (Partie 3)

- Eureka Server démarre et expose le dashboard sur `http://localhost:8761`.
- Les deux microservices (`produits-service`, `avis-service`) s'enregistrent automatiquement à Eureka.
- API Gateway route correctement les requêtes vers les services via leurs noms d'application.
- Feign client dans avis-service appelle `produits-service` pour valider l'existence du produit.
- Le service retourne 404 si le produit est introuvable lors du POST sur `/api/avis`.
