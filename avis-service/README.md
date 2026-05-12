# Avis-Service README

## Overview

`avis-service` is a Spring Boot 4 microservice for managing product reviews (avis). It validates product existence via Feign client calling `produits-service` and stores reviews in a separate PostgreSQL database.

## Features

- REST API for managing product reviews
- Feign client integration to verify product existence
- Layered architecture (controller → service → repository)
- OpenAPI/Swagger documentation
- PostgreSQL persistence (separate database)
- Validation (note: 1-5 rating scale)

## Architecture

```
Controller (GET /{produitId}, POST)
    ↓
Service (validation + Feign call)
    ↓
Repository (JPA)
    ↓
PostgreSQL (avis_db)
```

## Endpoints

### GET /api/avis/{produitId}
Returns all reviews for a specific product.

**Response (200 OK):**
```json
[
  {
    "id": 1,
    "produitId": 1,
    "auteur": "Jean Dupont",
    "commentaire": "Excellent produit!",
    "note": 5
  }
]
```

**Error (404):**
- Product not found in produits-service

### POST /api/avis
Create a new review for a product.

**Request Body:**
```json
{
  "produitId": 1,
  "auteur": "Jean Dupont",
  "commentaire": "Excellent produit!",
  "note": 5
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "produitId": 1,
  "auteur": "Jean Dupont",
  "commentaire": "Excellent produit!",
  "note": 5
}
```

**Validation Errors (400):**
- `auteur` must not be blank
- `commentaire` must not be blank
- `note` must be between 1 and 5
- `produitId` must not be null

**Error (404):**
- Product not found in produits-service

## Configuration

**Port:** 8092

**Environment Variables:**
- `SPRING_DATASOURCE_HOST`: PostgreSQL host (default: localhost)
- `SPRING_DATASOURCE_PORT`: PostgreSQL port (default: 5432)
- `SPRING_DATASOURCE_USERNAME`: Database user (default: postgres)
- `SPRING_DATASOURCE_PASSWORD`: Database password (default: postgres)

**Feign Client:**
- Calls `produits-service` on `http://produits-service:8091/api/produits/{id}`
- Used to validate product existence before creating/reading reviews

## Database

### Schema

**Table: avis**
- `id` (BIGINT, PK, AUTO_INCREMENT)
- `produit_id` (BIGINT, NOT NULL) - Reference to product in produits-service
- `auteur` (VARCHAR, NOT NULL) - Review author
- `commentaire` (TEXT, NOT NULL) - Review comment
- `note` (INTEGER, NOT NULL) - Rating (1-5)

## Build & Run

### Build
```bash
mvn clean package -DskipTests
```

### Run (Local)
```bash
mvn spring-boot:run
```

### Docker
```bash
docker build -t avis-service:1.0 .
docker run -p 8092:8092 -e SPRING_DATASOURCE_HOST=postgres avis-service:1.0
```

### Docker Compose
```bash
docker compose up avis-service
```

## Swagger/OpenAPI

Access API documentation at:
```
http://localhost:8092/swagger-ui.html
```

## Dependencies

- Spring Boot 4.0.6
- Spring Data JPA
- Spring Cloud OpenFeign 4.1.3
- PostgreSQL driver
- Jakarta validation
- springdoc-openapi 2.8.9 (Swagger)
- Lombok

## Integration with produits-service

avis-service depends on produits-service for:
1. Validating that a product exists before creating a review
2. Returning 404 if product is not found in produits-service

The Feign client automatically calls `GET /api/produits/{id}` on produits-service.

## Testing

See [py-test/README.md](../../py-test/README.md) for testing both services.
