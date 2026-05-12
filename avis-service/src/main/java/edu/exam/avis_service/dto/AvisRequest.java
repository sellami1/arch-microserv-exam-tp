package edu.exam.avis_service.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

public record AvisRequest(
    @NotNull Long produitId,
    @NotBlank String auteur,
    @NotBlank String commentaire,
    @NotNull @Min(1) @Max(5) Integer note
) {
}
