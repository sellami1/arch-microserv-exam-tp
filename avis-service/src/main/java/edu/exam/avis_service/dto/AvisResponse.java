package edu.exam.avis_service.dto;

public record AvisResponse(
    Long id,
    Long produitId,
    String auteur,
    String commentaire,
    Integer note
) {
}
