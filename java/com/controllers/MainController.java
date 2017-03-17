package com.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("project")
public class MainController {

	
	@RequestMapping(value = "/home", method = RequestMethod.GET)
	public String getPostList(Model model) {
		return "home";
	}
}
