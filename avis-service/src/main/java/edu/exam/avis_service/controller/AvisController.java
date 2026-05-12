package edu.exam.avis_service.controller;

import edu.exam.avis_service.dto.AvisRequest;
import edu.exam.avis_service.dto.AvisResponse;
import edu.exam.avis_service.service.AvisService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/avis")
public class AvisController {

    private final AvisService avisService;

    public AvisController(AvisService avisService) {
        this.avisService = avisService;
    }

    @GetMapping("/{produitId}")
    public List<AvisResponse> getAvisByProduitId(@PathVariable Long produitId) {
        return avisService.getAvisByProduitId(produitId);
    }

    @PostMapping
    public ResponseEntity<AvisResponse> createAvis(@Valid @RequestBody AvisRequest request) {
        AvisResponse createdAvis = avisService.createAvis(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdAvis);
    }
}
