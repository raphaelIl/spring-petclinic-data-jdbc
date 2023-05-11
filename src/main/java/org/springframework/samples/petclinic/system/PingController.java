package org.springframework.samples.petclinic.system;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PingController {

    @GetMapping("/ping")
    public String ping(HttpServletRequest request) {
        String clientIp = request.getRemoteAddr();

        System.out.println("Client IP: " + clientIp);

        return "pong";
    }
}
