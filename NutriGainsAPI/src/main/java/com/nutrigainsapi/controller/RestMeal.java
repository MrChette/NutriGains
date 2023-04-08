package com.nutrigainsapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.MealModel;
import com.nutrigainsapi.service.GenericService;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@RestController
@RequestMapping("/api")
public class RestMeal {
	
	@Autowired
	@Qualifier("mealServiceImpl")
	private GenericService<Meal,MealModel,Long> mealService;
	
	//Crear una comida (desayuno,almuerzo,cena)
	@PostMapping("/user/{id}/newmeal")
	public ResponseEntity<?> createNewMeal(@PathVariable (name="id", required = true) long id){
		MealModel mealModel = new MealModel();
		
		LocalDateTime localDateTime = LocalDateTime.now();
		ZoneId zoneId = ZoneId.systemDefault();
		Instant instant = localDateTime.atZone(zoneId).toInstant();
		Date date = Date.from(instant);
		
		mealModel.setIdUser(id);
		mealModel.setDate(date);		
		mealService.addEntity(mealModel);

		return ResponseEntity.status(HttpStatus.CREATED).body(mealModel);

	}

}
