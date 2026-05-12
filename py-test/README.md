# Produits-Service API Test Suite

Colorful Python test script for the **produits-service** REST API endpoints.

## Overview

This test suite validates all endpoints of the produits-service microservice:
- ✓ GET all categories
- ✓ GET category by ID
- ✓ GET all products
- ✓ GET products by category
- ✓ GET product by ID
- ✓ POST create product (valid & invalid data)

## Features

- 🎨 **Colorful Output**: ANSI-colored test results with ✓/✗ indicators
- 📊 **Detailed Reporting**: Error messages, status codes, and response data
- 🔍 **Validation Testing**: Tests both valid and invalid API inputs
- 📈 **Summary Report**: Final test statistics and success rate
- 🚫 **Error Handling**: Comprehensive error messages for debugging

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
PRODUITS-SERVICE API ENDPOINT TESTS
======================================================================

ℹ Testing API at: http://homserver:8091

▶ Category Endpoints
✓ GET /api/categories
  └─ Found 3 categories
✓ GET /api/categories/1
  └─ Category: Electronique

▶ Product Endpoints - Read Operations
✓ GET /api/produits
  └─ Found 5 products
✓ GET /api/produits/1
  └─ Product: Smartphone | Prix: 999.99€
✓ GET /api/produits?categorieId=1
  └─ Found 2 products in category 1

▶ Product Endpoints - Write Operations
✓ POST /api/produits
  └─ Product created: Test Product (ID: 6)
✓ POST /api/produits (invalid data validation)
  └─ Correctly rejected invalid data with HTTP 400

======================================================================
TEST SUMMARY REPORT
======================================================================

Total Tests: 8
Passed: 8
Failed: 0

✓ All tests passed! (Success rate: 100.0%)

Timestamp: 2026-05-12 14:32:15
```

## Customization

Edit the `test_endpoints.py` to:

- **Change hostname**: Modify the `base_url` parameter in the `APITester()` initialization
- **Add more tests**: Extend the `APITester` class with additional test methods
- **Modify test data**: Update the `valid_product` and `invalid_product` dictionaries in `main()`

## Connection Errors

If tests fail with connection errors, verify:

1. **API is running**: `docker compose up` or `mvn spring-boot:run`
2. **Hostname is correct**: `homserver` should be accessible (edit `/etc/hosts` if needed)
3. **Port is correct**: Default is `8091`, verify in `application.yml`
4. **Network**: Ensure network connectivity to the API host

## Test Coverage

| Endpoint | Method | Status | Error Handling |
|----------|--------|--------|---|
| `/api/categories` | GET | ✓ | Connection, empty response |
| `/api/categories/{id}` | GET | ✓ | 404, invalid format, connection |
| `/api/produits` | GET | ✓ | Connection, empty response |
| `/api/produits?categorieId={id}` | GET | ✓ | Invalid format, connection |
| `/api/produits/{id}` | GET | ✓ | 404, invalid format, connection |
| `/api/produits` | POST | ✓ | 400 validation, connection |

## Notes

- **Hostname**: Default is `homserver` (change in `APITester(base_url="...")` if needed)
- **No cache headers**: Tests do not check Redis cache behavior (cache is transparent to HTTP)
- **Seed data**: Tests assume initial seed data from `data.sql` is loaded (3 categories, 5 products)
