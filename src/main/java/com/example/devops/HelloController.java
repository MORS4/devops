package com.example.devops;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
  static final String MESSAGE = "Bonjour et bon courage dans votre projet en DevOps";

  @GetMapping("/")
  public String hello() {
    return MESSAGE;
  }
}

