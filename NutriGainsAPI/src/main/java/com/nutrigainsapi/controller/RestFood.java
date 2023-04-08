package com.nutrigainsapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.service.GenericService;

@RestController
@RequestMapping("/api")
public class RestFood {
	
	@Autowired
	@Qualifier("foodServiceImpl")
	private GenericService<Food,FoodModel,Long> foodService;
	
	//Crear un alimento
	@PostMapping("/user/{id}/newfood")
	public ResponseEntity<?> createFood(@PathVariable (name="id", required = true) long id,
			@RequestBody FoodModel foodModel){
		foodModel.setIdUser(id);
		foodService.addEntity(foodModel);
		return ResponseEntity.status(HttpStatus.CREATED).body(foodModel);
	}

}
