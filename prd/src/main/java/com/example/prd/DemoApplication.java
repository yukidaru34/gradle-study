package com.example.prd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.example.ysy.Ysy;

@SpringBootApplication
public class DemoApplication {

	public static void main(String[] args) {

		System.out.println(new Ysy().toString());
		SpringApplication.run(DemoApplication.class, args);
	}

}
