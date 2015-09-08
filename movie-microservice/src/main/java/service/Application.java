package service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.circuitbreaker.EnableCircuitBreaker;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestMvcConfiguration;
import service.data.domain.Movie;
import service.data.domain.Genre;

import javax.annotation.PostConstruct;

@SpringBootApplication
@ComponentScan(basePackages = { "service.config", "service.data" })
@EnableZuulProxy
@EnableCircuitBreaker
public class Application {

    @Autowired
    private RepositoryRestMvcConfiguration repositoryRestConfiguration;

    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }

    @PostConstruct
    public void postConstructConfiguration() {
        RepositoryRestConfiguration configuration = repositoryRestConfiguration.config();
        configuration.setBasePath("/api");
        configuration.exposeIdsFor(Movie.class);
        configuration.exposeIdsFor(Genre.class);
    }
}
