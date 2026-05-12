package edu.exam.produits_service.repository;

import edu.exam.produits_service.entity.Categorie;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategorieRepository extends JpaRepository<Categorie, Long> {
}