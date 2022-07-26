package com.app.springboothelloworld.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.ArrayList;
import java.util.List;

@RestController
class HelloController {

    @RequestMapping("/hello")
    public String hello() {
        List<byte[]> list = new ArrayList<>();
        int index = 1;
        while (true) {
            // 1MB each loop, 1 x 1024 x 1024 = 100048576 = 100mb
            byte[] b = new byte[100048576];
            list.add(b);
            Runtime rt = Runtime.getRuntime();
            System.out.printf("[%d] free memory: %s%n", index++, rt.freeMemory());
            //return "Hello World restful with Spring Boot";
        }
    }
}
