package edu.exam.produits_service.mapper;

import edu.exam.produits_service.dto.ProduitRequest;
import edu.exam.produits_service.dto.ProduitResponse;
import edu.exam.produits_service.entity.Categorie;
import edu.exam.produits_service.entity.Produit;

public final class ProduitMapper {

    private ProduitMapper() {
    }

    public static Produit toEntity(ProduitRequest request, Categorie categorie) {
        return Produit.builder()
            .nom(request.nom())
            .prix(request.prix())
            .stock(request.stock())
            .categorie(categorie)
            .build();
    }

    public static ProduitResponse toResponse(Produit produit) {
        return new ProduitResponse(
            produit.getId(),
            produit.getNom(),
            produit.getPrix(),
            produit.getStock(),
            CategorieMapper.toResponse(produit.getCategorie())
        );
    }
}