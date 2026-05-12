package edu.exam.produits_service.controller;

import edu.exam.produits_service.dto.CategorieResponse;
import edu.exam.produits_service.service.CategorieService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/categories")
public class CategorieController {

    private final CategorieService categorieService;

    public CategorieController(CategorieService categorieService) {
        this.categorieService = categorieService;
    }

    @GetMapping
    public List<CategorieResponse> getAllCategories() {
        return categorieService.getAllCategories();
    }

    @GetMapping("/{id}")
    public CategorieResponse getCategoryById(@PathVariable Long id) {
        return categorieService.getCategoryById(id);
    }
}