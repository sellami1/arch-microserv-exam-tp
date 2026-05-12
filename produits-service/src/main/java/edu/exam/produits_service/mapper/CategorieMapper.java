package edu.exam.produits_service.mapper;

import edu.exam.produits_service.dto.CategorieResponse;
import edu.exam.produits_service.entity.Categorie;

public final class CategorieMapper {

    private CategorieMapper() {
    }

    public static CategorieResponse toResponse(Categorie categorie) {
        return new CategorieResponse(categorie.getId(), categorie.getNom());
    }
}