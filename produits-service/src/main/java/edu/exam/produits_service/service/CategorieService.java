package edu.exam.produits_service.service;

import edu.exam.produits_service.dto.CategorieResponse;
import edu.exam.produits_service.entity.Categorie;
import edu.exam.produits_service.exception.ResourceNotFoundException;
import edu.exam.produits_service.mapper.CategorieMapper;
import edu.exam.produits_service.repository.CategorieRepository;
import java.util.List;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class CategorieService {

    private final CategorieRepository categorieRepository;

    public CategorieService(CategorieRepository categorieRepository) {
        this.categorieRepository = categorieRepository;
    }

    public List<CategorieResponse> getAllCategories() {
        return categorieRepository.findAll(Sort.by(Sort.Direction.ASC, "nom"))
            .stream()
            .map(CategorieMapper::toResponse)
            .toList();
    }

    public CategorieResponse getCategoryById(Long id) {
        return CategorieMapper.toResponse(getCategoryEntityById(id));
    }

    public Categorie getCategoryEntityById(Long id) {
        return categorieRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Categorie introuvable: " + id));
    }
}