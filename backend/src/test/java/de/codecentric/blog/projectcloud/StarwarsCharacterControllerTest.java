package de.codecentric.blog.projectcloud;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import java.util.Arrays;
import java.util.List;

import static junit.framework.TestCase.assertTrue;
import static org.junit.Assert.assertEquals;

@RunWith(SpringRunner.class)
@SpringBootTest
@AutoConfigureMockMvc
public class StarwarsCharacterControllerTest extends AbstractTest{

    private List<String> names = Arrays.asList("Darth Vader", "Luke Skywalker", "R2-D2", "C3-PO");

    @Autowired
    private MockMvc mvc;

    @Test
    public void getCharacter() throws Exception {
        MvcResult mvcResult = mvc.perform(MockMvcRequestBuilders.get("/starwars-character").accept(MediaType.APPLICATION_JSON)).andReturn();

        assertEquals(200, mvcResult.getResponse().getStatus());
        System.out.println(mvcResult.getResponse().getContentAsString());
        StarwarsCharacter character = super.mapFromJson(mvcResult.getResponse().getContentAsString(), StarwarsCharacter.class);
        assertTrue(names.contains(character.getName()));
    }
}
