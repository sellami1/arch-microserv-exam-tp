package edu.exam.produits_service.service;

import edu.exam.produits_service.dto.ProduitRequest;
import edu.exam.produits_service.dto.ProduitResponse;
import edu.exam.produits_service.entity.Produit;
import edu.exam.produits_service.exception.ResourceNotFoundException;
import edu.exam.produits_service.mapper.ProduitMapper;
import edu.exam.produits_service.repository.CategorieRepository;
import edu.exam.produits_service.repository.ProduitRepository;
import java.util.List;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ProduitService {

    private final ProduitRepository produitRepository;
    private final CategorieRepository categorieRepository;

    public ProduitService(ProduitRepository produitRepository, CategorieRepository categorieRepository) {
        this.produitRepository = produitRepository;
        this.categorieRepository = categorieRepository;
    }

    @Cacheable(cacheNames = "produits", key = "#categorieId == null ? 'all' : 'categorie:' + #categorieId")
    @Transactional(readOnly = true)
    public List<ProduitResponse> getProduits(Long categorieId) {
        if (categorieId != null && !categorieRepository.existsById(categorieId)) {
            throw new ResourceNotFoundException("Categorie introuvable: " + categorieId);
        }

        List<Produit> produits = categorieId == null
            ? produitRepository.findAll(Sort.by(Sort.Direction.ASC, "id"))
            : produitRepository.findByCategorieIdOrderByIdAsc(categorieId);

        return produits.stream()
            .map(ProduitMapper::toResponse)
            .toList();
    }

    @Transactional(readOnly = true)
    public ProduitResponse getProduitById(Long id) {
        return ProduitMapper.toResponse(getProduitEntityById(id));
    }

    @CacheEvict(cacheNames = "produits", allEntries = true)
    public ProduitResponse createProduit(ProduitRequest request) {
        var categorie = categorieRepository.findById(request.categorieId())
            .orElseThrow(() -> new ResourceNotFoundException("Categorie introuvable: " + request.categorieId()));

        Produit produit = ProduitMapper.toEntity(request, categorie);
        Produit savedProduit = produitRepository.save(produit);
        return ProduitMapper.toResponse(savedProduit);
    }

    public Produit getProduitEntityById(Long id) {
        return produitRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Produit introuvable: " + id));
    }
}