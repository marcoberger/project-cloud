package de.codecentric.blog.projectcloud;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.web.server.LocalServerPort;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.junit4.SpringRunner;

import java.net.URL;
import java.util.Arrays;
import java.util.List;

import static junit.framework.TestCase.assertTrue;

@RunWith(SpringRunner.class)
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@TestPropertySource(properties = {"management.port=0"})
public class StarwarsCharacterControllerIT extends AbstractTest{

    private List<String> names = Arrays.asList("Darth Vader", "Luke Skywalker", "R2-D2", "C3-PO");

    @LocalServerPort
    private int port;

    private URL base;

    @Autowired
    private TestRestTemplate template;

    @Before
    public void setUp() throws Exception {
        this.base = new URL("http://localhost:" + port + "/starwars-character");
    }

    @Test
    public void getCharacter() throws Exception {
        ResponseEntity<String> response = template.getForEntity(base.toString(),
                String.class);
        StarwarsCharacter character = super.mapFromJson(response.getBody(), StarwarsCharacter.class);
        assertTrue(names.contains(character.getName()));
    }
}
