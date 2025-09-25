package com.example.sangwoo;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class TestController {

    @GetMapping("/")
    public String home(){
        return "Hello CICD with Docker !!";
    }

}
