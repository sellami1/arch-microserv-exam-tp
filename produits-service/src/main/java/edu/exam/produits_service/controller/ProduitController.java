package edu.exam.produits_service.controller;

import edu.exam.produits_service.dto.ProduitRequest;
import edu.exam.produits_service.dto.ProduitResponse;
import edu.exam.produits_service.service.ProduitService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/produits")
public class ProduitController {

    private final ProduitService produitService;

    public ProduitController(ProduitService produitService) {
        this.produitService = produitService;
    }

    @GetMapping
    public List<ProduitResponse> getProduits(@RequestParam(required = false) Long categorieId) {
        return produitService.getProduits(categorieId);
    }

    @GetMapping("/{id}")
    public ProduitResponse getProduitById(@PathVariable Long id) {
        return produitService.getProduitById(id);
    }

    @PostMapping
    public ResponseEntity<ProduitResponse> createProduit(@Valid @RequestBody ProduitRequest request) {
        ProduitResponse createdProduit = produitService.createProduit(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdProduit);
    }
}