package edu.exam.avis_service.mapper;

import edu.exam.avis_service.dto.AvisRequest;
import edu.exam.avis_service.dto.AvisResponse;
import edu.exam.avis_service.entity.Avis;

public class AvisMapper {

    public static AvisResponse toResponse(Avis avis) {
        return new AvisResponse(
            avis.getId(),
            avis.getProduitId(),
            avis.getAuteur(),
            avis.getCommentaire(),
            avis.getNote()
        );
    }

    public static Avis toEntity(AvisRequest request) {
        return Avis.builder()
            .produitId(request.produitId())
            .auteur(request.auteur())
            .commentaire(request.commentaire())
            .note(request.note())
            .build();
    }
}
