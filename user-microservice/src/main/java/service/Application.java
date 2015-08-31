package service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.hystrix.EnableHystrix;
import org.springframework.cloud.netflix.zuul.EnableZuulProxy;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.rest.webmvc.config.RepositoryRestMvcConfiguration;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.Resource;
import org.springframework.hateoas.ResourceProcessor;
import org.springframework.hateoas.hal.Jackson2HalModule;

import javax.annotation.PostConstruct;

import lombok.extern.slf4j.Slf4j;
import service.data.config.GraphDatabaseConfiguration;
import service.data.domain.entity.User;

@SpringBootApplication
@ComponentScan({ "service.data", "service.config" })
@EnableZuulProxy
@EnableHystrix
@Slf4j
public class Application {

    final Logger logger = LoggerFactory.getLogger(Application.class);

    @Value("${neo4j.bootstrap}")
    Boolean bootstrap;

    // Used to bootstrap the Neo4j database with demo data
    @Value("${aws.s3.url}")
    String datasetUrl;

    @Autowired
    RepositoryRestMvcConfiguration restConfiguration;

    public static void main(String[] args) {
        System.setProperty("org.neo4j.rest.read_timeout", "250");
        SpringApplication.run(Application.class, args);
    }

    @PostConstruct
    public void postConstructConfiguration() {
        // Expose ids for the domain entities having repositories
        logger.info("Exposing IDs on repositories...");
        restConfiguration.config().exposeIdsFor(User.class);

        // Register the ObjectMapper module for properly rendering HATEOAS REST repositories
        logger.info("Registering Jackson2HalModule...");
        restConfiguration.objectMapper().registerModule(new Jackson2HalModule());
    }

    @Bean
    public CommandLineRunner commandLineRunner(GraphDatabaseConfiguration graphDatabaseConfiguration) {
        return strings -> {
            if(bootstrap) {
                // Import graph data for users
                String userImport = String.format(
                    "LOAD CSV WITH HEADERS FROM \"%s/users.csv\" AS csvLine\n" +
                    "MERGE (user:User:_User { "
                    + "id: csvLine.id, age: toInt(csvLine.age), "
                    + "gender: csvLine.gender, "
                    + "occupation: csvLine.occupation, "
                    + "zipcode: csvLine.zipcode })", datasetUrl);

                graphDatabaseConfiguration.neo4jTemplate().query(userImport, null).finish();
                logger.info("Users import complete");
            }
        };
    }

    @Bean
    public ResourceProcessor<Resource<User>> movieProcessor() {
        return new ResourceProcessor<Resource<User>>() {
            @Override
            public Resource<User> process(Resource<User> resource) {

                resource.add(new Link("/movie/movies", "movies"));
                return resource;
            }
        };
    }
}
