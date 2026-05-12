package edu.exam.avis_service.repository;

import edu.exam.avis_service.entity.Avis;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AvisRepository extends JpaRepository<Avis, Long> {

    List<Avis> findByProduitIdOrderByIdDesc(Long produitId);
}
