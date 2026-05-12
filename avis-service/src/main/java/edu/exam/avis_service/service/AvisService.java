package edu.exam.avis_service.service;

import edu.exam.avis_service.client.ProduitsServiceClient;
import edu.exam.avis_service.dto.AvisRequest;
import edu.exam.avis_service.dto.AvisResponse;
import edu.exam.avis_service.entity.Avis;
import edu.exam.avis_service.exception.ResourceNotFoundException;
import edu.exam.avis_service.mapper.AvisMapper;
import edu.exam.avis_service.repository.AvisRepository;
import java.util.List;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class AvisService {

    private final AvisRepository avisRepository;
    private final ProduitsServiceClient produitsServiceClient;

    public AvisService(AvisRepository avisRepository, ProduitsServiceClient produitsServiceClient) {
        this.avisRepository = avisRepository;
        this.produitsServiceClient = produitsServiceClient;
    }

    @Transactional(readOnly = true)
    public List<AvisResponse> getAvisByProduitId(Long produitId) {
        // Verify product exists
        try {
            produitsServiceClient.getProduitById(produitId);
        } catch (Exception e) {
            throw new ResourceNotFoundException("Produit introuvable: " + produitId);
        }

        return avisRepository.findByProduitIdOrderByIdDesc(produitId).stream()
            .map(AvisMapper::toResponse)
            .toList();
    }

    public AvisResponse createAvis(AvisRequest request) {
        // Verify product exists before creating review
        try {
            produitsServiceClient.getProduitById(request.produitId());
        } catch (Exception e) {
            throw new ResourceNotFoundException("Produit introuvable: " + request.produitId());
        }

        Avis avis = AvisMapper.toEntity(request);
        Avis savedAvis = avisRepository.save(avis);
        return AvisMapper.toResponse(savedAvis);
    }
}
