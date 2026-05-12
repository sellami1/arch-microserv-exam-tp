package edu.exam.produits_service.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    OpenAPI produitsServiceOpenAPI() {
        return new OpenAPI().info(new Info()
            .title("produits-service API")
            .description("API de gestion des produits et catégories")
            .version("v1"));
    }
}