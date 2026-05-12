package edu.exam.produits_service.dto;

public record ProduitResponse(Long id, String nom, Double prix, Integer stock, CategorieResponse categorie) {
}