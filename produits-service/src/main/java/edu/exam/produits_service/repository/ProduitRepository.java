package edu.exam.produits_service.repository;

import edu.exam.produits_service.entity.Produit;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ProduitRepository extends JpaRepository<Produit, Long> {

    List<Produit> findByCategorieIdOrderByIdAsc(Long categorieId);
}