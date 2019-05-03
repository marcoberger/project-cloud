package de.codecentric.blog.projectcloud;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Arrays;
import java.util.List;
import java.util.Random;
import java.util.concurrent.atomic.AtomicLong;

@Controller
public class StarwarsCharacterController {

    private final AtomicLong counter = new AtomicLong();

    @GetMapping("/starwars-character")
    @ResponseBody
    public StarwarsCharacter getRandomCharacter(@RequestParam(name="name", required=false, defaultValue="Stranger") String name) {
        return new StarwarsCharacter(counter.incrementAndGet(), getRandomName(), isJedi());
    }

    private String getRandomName() {
        List<String> givenList = Arrays.asList("Darth Vader", "Luke Skywalker", "R2-D2", "C3-PO");
        Random rand = new Random();
        int randomIndex = rand.nextInt(givenList.size());
        return givenList.get(randomIndex);
    }

    private boolean isJedi() {
        return Math.random() < 0.5;
    }

}
