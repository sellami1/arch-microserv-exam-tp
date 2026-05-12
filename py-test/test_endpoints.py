#!/usr/bin/env python3
"""
Colorful API endpoint tester for produits-service
Tests all REST endpoints with detailed error reporting
"""

import requests
import json
from datetime import datetime
from typing import Dict, Any, Tuple

# ANSI Color codes
class Colors:
    RESET = '\033[0m'
    BOLD = '\033[1m'
    
    # Foreground colors
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    
    # Background colors
    BG_RED = '\033[41m'
    BG_GREEN = '\033[42m'
    
    @staticmethod
    def success(text: str) -> str:
        return f"{Colors.GREEN}✓{Colors.RESET} {text}"
    
    @staticmethod
    def error(text: str) -> str:
        return f"{Colors.RED}✗{Colors.RESET} {text}"
    
    @staticmethod
    def warning(text: str) -> str:
        return f"{Colors.YELLOW}⚠{Colors.RESET} {text}"
    
    @staticmethod
    def info(text: str) -> str:
        return f"{Colors.BLUE}ℹ{Colors.RESET} {text}"
    
    @staticmethod
    def header(text: str) -> str:
        return f"{Colors.BOLD}{Colors.CYAN}{'='*70}{Colors.RESET}\n{Colors.BOLD}{Colors.CYAN}{text}{Colors.RESET}\n{Colors.BOLD}{Colors.CYAN}{'='*70}{Colors.RESET}"
    
    @staticmethod
    def section(text: str) -> str:
        return f"\n{Colors.BOLD}{Colors.BLUE}▶ {text}{Colors.RESET}"


class APITester:
    def __init__(self, base_url: str = "http://localhost:8091"):
        self.base_url = base_url.rstrip('/')
        self.test_results = []
        self.total_tests = 0
        self.passed_tests = 0
        self.failed_tests = 0
        
    def log_test(self, name: str, passed: bool, message: str = "", error: str = ""):
        """Log test result"""
        self.total_tests += 1
        self.test_results.append({
            'name': name,
            'passed': passed,
            'message': message,
            'error': error
        })
        
        if passed:
            self.passed_tests += 1
            print(Colors.success(f"{name}"))
            if message:
                print(f"  └─ {Colors.CYAN}{message}{Colors.RESET}")
        else:
            self.failed_tests += 1
            print(Colors.error(f"{name}"))
            if message:
                print(f"  └─ {message}")
            if error:
                print(f"  └─ {Colors.RED}Error: {error}{Colors.RESET}")
    
    def test_get_all_categories(self) -> None:
        """Test: GET /api/categories"""
        try:
            response = requests.get(f"{self.base_url}/api/categories", timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list) and len(data) > 0:
                    self.log_test(
                        "GET /api/categories",
                        True,
                        f"Found {len(data)} categories"
                    )
                    return data
                else:
                    self.log_test(
                        "GET /api/categories",
                        False,
                        f"Response is empty or invalid: {data}",
                        "No categories returned"
                    )
            else:
                self.log_test(
                    "GET /api/categories",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                "GET /api/categories",
                False,
                f"Connection failed",
                str(e)
            )
        return []
    
    def test_get_category_by_id(self, category_id: int = 1) -> None:
        """Test: GET /api/categories/{id}"""
        try:
            response = requests.get(f"{self.base_url}/api/categories/{category_id}", timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                if data.get('id') and data.get('nom'):
                    self.log_test(
                        f"GET /api/categories/{category_id}",
                        True,
                        f"Category: {data.get('nom')}"
                    )
                else:
                    self.log_test(
                        f"GET /api/categories/{category_id}",
                        False,
                        f"Invalid response format",
                        f"Missing fields: {data}"
                    )
            elif response.status_code == 404:
                self.log_test(
                    f"GET /api/categories/{category_id}",
                    False,
                    f"HTTP 404 - Category not found",
                    "The category with ID {category_id} does not exist"
                )
            else:
                self.log_test(
                    f"GET /api/categories/{category_id}",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                f"GET /api/categories/{category_id}",
                False,
                f"Connection failed",
                str(e)
            )
    
    def test_get_all_products(self) -> None:
        """Test: GET /api/produits"""
        try:
            response = requests.get(f"{self.base_url}/api/produits", timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list) and len(data) > 0:
                    self.log_test(
                        "GET /api/produits",
                        True,
                        f"Found {len(data)} products"
                    )
                    return data
                else:
                    self.log_test(
                        "GET /api/produits",
                        False,
                        f"Response is empty or invalid",
                        "No products returned"
                    )
            else:
                self.log_test(
                    "GET /api/produits",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                "GET /api/produits",
                False,
                f"Connection failed",
                str(e)
            )
        return []
    
    def test_get_products_by_category(self, category_id: int = 1) -> None:
        """Test: GET /api/produits?categorieId={id}"""
        try:
            response = requests.get(
                f"{self.base_url}/api/produits",
                params={'categorieId': category_id},
                timeout=5
            )
            
            if response.status_code == 200:
                data = response.json()
                if isinstance(data, list):
                    self.log_test(
                        f"GET /api/produits?categorieId={category_id}",
                        True,
                        f"Found {len(data)} products in category {category_id}"
                    )
                else:
                    self.log_test(
                        f"GET /api/produits?categorieId={category_id}",
                        False,
                        f"Invalid response format",
                        f"Expected list, got: {type(data)}"
                    )
            else:
                self.log_test(
                    f"GET /api/produits?categorieId={category_id}",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                f"GET /api/produits?categorieId={category_id}",
                False,
                f"Connection failed",
                str(e)
            )
    
    def test_get_product_by_id(self, product_id: int = 1) -> None:
        """Test: GET /api/produits/{id}"""
        try:
            response = requests.get(f"{self.base_url}/api/produits/{product_id}", timeout=5)
            
            if response.status_code == 200:
                data = response.json()
                if data.get('id') and data.get('nom'):
                    self.log_test(
                        f"GET /api/produits/{product_id}",
                        True,
                        f"Product: {data.get('nom')} | Prix: {data.get('prix')}€"
                    )
                else:
                    self.log_test(
                        f"GET /api/produits/{product_id}",
                        False,
                        f"Invalid response format",
                        f"Missing required fields"
                    )
            elif response.status_code == 404:
                self.log_test(
                    f"GET /api/produits/{product_id}",
                    False,
                    f"HTTP 404 - Product not found",
                    f"The product with ID {product_id} does not exist"
                )
            else:
                self.log_test(
                    f"GET /api/produits/{product_id}",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                f"GET /api/produits/{product_id}",
                False,
                f"Connection failed",
                str(e)
            )
    
    def test_create_product(self, product_data: Dict[str, Any]) -> None:
        """Test: POST /api/produits"""
        try:
            response = requests.post(
                f"{self.base_url}/api/produits",
                json=product_data,
                timeout=5
            )
            
            if response.status_code == 201:
                data = response.json()
                self.log_test(
                    "POST /api/produits",
                    True,
                    f"Product created: {data.get('nom')} (ID: {data.get('id')})"
                )
            elif response.status_code == 400:
                self.log_test(
                    "POST /api/produits",
                    False,
                    f"HTTP 400 - Bad Request",
                    response.text
                )
            else:
                self.log_test(
                    "POST /api/produits",
                    False,
                    f"HTTP {response.status_code}",
                    response.text
                )
        except Exception as e:
            self.log_test(
                "POST /api/produits",
                False,
                f"Connection failed",
                str(e)
            )
    
    def test_create_product_invalid(self, product_data: Dict[str, Any]) -> None:
        """Test: POST /api/produits with invalid data"""
        try:
            response = requests.post(
                f"{self.base_url}/api/produits",
                json=product_data,
                timeout=5
            )
            
            if response.status_code == 400:
                self.log_test(
                    "POST /api/produits (invalid data validation)",
                    True,
                    f"Correctly rejected invalid data with HTTP 400"
                )
            else:
                self.log_test(
                    "POST /api/produits (invalid data validation)",
                    False,
                    f"Expected HTTP 400, got HTTP {response.status_code}",
                    "Invalid data should be rejected"
                )
        except Exception as e:
            self.log_test(
                "POST /api/produits (invalid data validation)",
                False,
                f"Connection failed",
                str(e)
            )
    
    def print_summary(self) -> None:
        """Print test summary report"""
        print(Colors.header("TEST SUMMARY REPORT"))
        print(f"\n{Colors.BOLD}Total Tests:{Colors.RESET} {self.total_tests}")
        print(f"{Colors.GREEN}{Colors.BOLD}Passed:{Colors.RESET} {self.passed_tests}")
        print(f"{Colors.RED}{Colors.BOLD}Failed:{Colors.RESET} {self.failed_tests}")
        
        if self.failed_tests > 0:
            print(f"\n{Colors.section('Failed Tests Details')}")
            for result in self.test_results:
                if not result['passed']:
                    print(f"\n{Colors.RED}✗ {result['name']}{Colors.RESET}")
                    if result['message']:
                        print(f"  Message: {result['message']}")
                    if result['error']:
                        print(f"  Error: {result['error']}")
        
        success_rate = (self.passed_tests / self.total_tests * 100) if self.total_tests > 0 else 0
        
        if self.failed_tests == 0:
            print(f"\n{Colors.GREEN}{Colors.BOLD}✓ All tests passed! (Success rate: {success_rate:.1f}%){Colors.RESET}")
        else:
            print(f"\n{Colors.RED}{Colors.BOLD}✗ Some tests failed (Success rate: {success_rate:.1f}%){Colors.RESET}")
        
        print(f"\n{Colors.BOLD}Timestamp:{Colors.RESET} {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")


def main():
    """Main test execution"""
    print(Colors.header("PRODUITS-SERVICE API ENDPOINT TESTS"))
    print(f"\n{Colors.info(f'Testing API at: http://homserver:8091')}\n")
    
    tester = APITester()
    
    # Test 1: Get all categories
    print(Colors.section("Category Endpoints"))
    categories = tester.test_get_all_categories()
    if categories:
        tester.test_get_category_by_id(categories[0].get('id', 1))
    
    # Test 2: Get all products
    print(Colors.section("Product Endpoints - Read Operations"))
    products = tester.test_get_all_products()
    if products:
        tester.test_get_product_by_id(products[0].get('id', 1))
    
    # Test 3: Get products by category
    if categories:
        tester.test_get_products_by_category(categories[0].get('id', 1))
    
    # Test 4: Create valid product
    print(Colors.section("Product Endpoints - Write Operations"))
    valid_product = {
        "nom": "Test Product",
        "prix": 99.99,
        "stock": 10,
        "categorieId": categories[0].get('id', 1) if categories else 1
    }
    tester.test_create_product(valid_product)
    
    # Test 5: Create invalid product (validation test)
    invalid_product = {
        "nom": "",  # Empty name should fail
        "prix": -10,  # Negative price should fail
        "stock": -5,  # Negative stock should fail
        "categorieId": 99999  # Non-existent category
    }
    tester.test_create_product_invalid(invalid_product)
    
    # Print summary
    tester.print_summary()


if __name__ == "__main__":
    main()
