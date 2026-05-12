package edu.exam.avis_service.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@FeignClient(name = "produits-service")
public interface ProduitsServiceClient {

    @GetMapping("/api/produits/{id}")
    ProduitDto getProduitById(@PathVariable Long id);

    record ProduitDto(Long id, String nom, Double prix, Integer stock) {
    }
}
