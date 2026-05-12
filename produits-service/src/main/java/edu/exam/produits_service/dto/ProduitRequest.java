package edu.exam.produits_service.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

public record ProduitRequest(
    @NotBlank String nom,
    @NotNull @Positive Double prix,
    @NotNull @PositiveOrZero Integer stock,
    @NotNull Long categorieId
) {
}