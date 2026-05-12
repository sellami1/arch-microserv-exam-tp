# Produits-Service & Avis-Service API Test Suite

Colorful Python test script for the **produits-service** and **avis-service** REST API endpoints.

## Overview

This test suite validates all endpoints of both microservices:

### Produits-Service (port 8091)
- ✓ GET all categories
- ✓ GET category by ID
- ✓ GET all products
- ✓ GET products by category
- ✓ GET product by ID
- ✓ POST create product (valid & invalid data)

### Avis-Service (port 8092)
- ✓ GET all reviews for a product
- ✓ POST create product review (valid & invalid data)

## Features

- 🎨 **Colorful Output**: ANSI-colored test results with ✓/✗ indicators
- 📊 **Detailed Reporting**: Error messages, status codes, and response data
- 🔍 **Validation Testing**: Tests both valid and invalid API inputs
- 📈 **Summary Report**: Final test statistics and success rate
- 🚫 **Error Handling**: Comprehensive error messages for debugging
- 🌐 **Multi-Service**: Tests both produits and avis services automatically

## Setup

### Prerequisites

- Python 3.7+
- `requests` library

### Installation

Install dependencies:

```bash
pip install -r requirements.txt
```

## Usage

Run the test suite:

```bash
python test_endpoints.py
```

### Expected Output

Example successful run:

```
======================================================================
PRODUITS-SERVICE & AVIS-SERVICE API ENDPOINT TESTS
======================================================================

ℹ Testing APIs at: http://homserver:8091 (produits) and http://homserver:8092 (avis)

▶ Category Endpoints (produits-service port 8091)
✓ GET /api/categories
  └─ Found 3 categories
✓ GET /api/categories/1
  └─ Category: Electronique

▶ Product Endpoints - Read Operations (produits-service port 8091)
✓ GET /api/produits
  └─ Found 5 products
✓ GET /api/produits/1
  └─ Product: Smartphone | Prix: 999.99€
✓ GET /api/produits?categorieId=1
  └─ Found 2 products in category 1

▶ Product Endpoints - Write Operations (produits-service port 8091)
✓ POST /api/produits
  └─ Product created: Test Product (ID: 6)
✓ POST /api/produits (invalid data validation)
  └─ Correctly rejected invalid data with HTTP 400

▶ Avis Endpoints - Read Operations (avis-service port 8092)
✓ GET /api/avis/1
  └─ Found 0 reviews for product 1

▶ Avis Endpoints - Write Operations (avis-service port 8092)
✓ POST /api/avis
  └─ Review created for product 1 by Test Reviewer (ID: 1)
✓ POST /api/avis (invalid data validation)
  └─ Correctly rejected with HTTP 404

======================================================================
TEST SUMMARY REPORT
======================================================================

Total Tests: 12
Passed: 12
Failed: 0

✓ All tests passed! (Success rate: 100.0%)

Timestamp: 2026-05-12 14:35:22
```

## Customization

Edit the `test_endpoints.py` to:

- **Change hostname**: Modify the `base_url` parameter in the `APITester()` initialization
- **Change ports**: Update the port replacement logic in `test_create_avis()` and `test_get_avis_by_produit()`
- **Add more tests**: Extend the `APITester` class with additional test methods
- **Modify test data**: Update the `valid_product`, `invalid_product`, `valid_avis`, and `invalid_avis` dictionaries in `main()`

## Connection Errors

If tests fail with connection errors, verify:

1. **APIs are running**: `docker compose up` or run services individually
2. **Hostname is correct**: `homserver` should be accessible
3. **Ports are correct**: 
   - produits-service: `8091`
   - avis-service: `8092`
4. **Network**: Ensure network connectivity to the API hosts

## Test Coverage

| Service | Endpoint | Method | Status | Error Handling |
|---------|----------|--------|--------|---|
| produits-service | `/api/categories` | GET | ✓ | Connection, empty response |
| produits-service | `/api/categories/{id}` | GET | ✓ | 404, invalid format, connection |
| produits-service | `/api/produits` | GET | ✓ | Connection, empty response |
| produits-service | `/api/produits?categorieId={id}` | GET | ✓ | Invalid format, connection |
| produits-service | `/api/produits/{id}` | GET | ✓ | 404, invalid format, connection |
| produits-service | `/api/produits` | POST | ✓ | 400 validation, connection |
| avis-service | `/api/avis/{produitId}` | GET | ✓ | 404, invalid format, connection |
| avis-service | `/api/avis` | POST | ✓ | 400 validation, 404 product not found, connection |

## Notes

- **Hostname**: Default is `homserver` (change in `APITester(base_url="...")` if needed)
- **Seed data**: Tests assume initial seed data from `data.sql` is loaded (3 categories, 5 products)
- **Port switching**: Test script automatically switches from port 8091 to 8092 for avis-service tests
- **Feign integration**: avis-service validates products exist in produits-service before creating reviews

