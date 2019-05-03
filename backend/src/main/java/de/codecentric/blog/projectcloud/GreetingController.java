package de.codecentric.blog.projectcloud;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class GreetingController {

    @RequestMapping("/greeting")
    public String index() {
        return "Greetings from Spring Boot of Project Cloud!";
    }

}
