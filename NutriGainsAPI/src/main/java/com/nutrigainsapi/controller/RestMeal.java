package com.nutrigainsapi.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.MealModel;
import com.nutrigainsapi.repository.MealRepository;
import com.nutrigainsapi.service.GenericService;
import com.nutrigainsapi.serviceImpl.MealServiceImpl;
import com.nutrigainsapi.serviceImpl.UserService;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api")
public class RestMeal {
	
	@Autowired
	@Qualifier("mealServiceImpl")
	private MealServiceImpl mealService;
	
	@Autowired
	@Qualifier("mealRepository")
	private MealRepository mealRepository;
	
	@Autowired
	@Qualifier("userService")
	private UserService userService;
	
	
	//Crear una comida (desayuno,almuerzo,cena)
//	@PostMapping("/user/newmeal")
//	@Operation(summary = "Crear una comida (desayuno,almuerzo,cena)" , description = " ... ")
//	public ResponseEntity<?> createNewMeal() throws ParseException{
//	    MealModel mealModel = new MealModel();
//
//	    LocalDateTime localDateTime = LocalDateTime.now();
//	    ZoneId zoneId = ZoneId.systemDefault();
//	    Instant instant = localDateTime.atZone(zoneId).toInstant();
//	    Date date = Date.from(instant);
//
//	    mealModel.setIdUser(userService.getUserId());
//	    mealModel.setDate(date);
//
//	    Meal mealEntity = mealService.transform(mealModel);
//	    mealRepository.save(mealEntity);
//	    mealModel.setId(mealEntity.getId());
//
//	    return ResponseEntity.status(HttpStatus.CREATED).body(mealModel);
//	}
	
	@PostMapping("/user/newfoodmeal/{idfood}/{grams}")
	@Operation(summary = "Crear una comida (desayuno,almuerzo,cena)" , description = " ... ")
	public ResponseEntity<?> newFoodMeal(@PathVariable(name="idfood",required = true) long idfood,
										 @PathVariable(name="grams",required = true) long grams) throws ParseException{
		MealModel mealModel = new MealModel();
		LocalDateTime localDateTime = LocalDateTime.now();
	    ZoneId zoneId = ZoneId.systemDefault();
	    Instant instant = localDateTime.atZone(zoneId).toInstant();
	    Date date = Date.from(instant);

	    mealModel.setIdUser(userService.getUserId());
	    mealModel.setDate(date);
		mealModel.setIdFood(idfood);
		mealModel.setGrams(grams);
		Meal mealEntity = mealService.transform(mealModel);
	    mealRepository.save(mealEntity);
	    mealModel.setId(mealEntity.getId());
	    return ResponseEntity.status(HttpStatus.CREATED).body(mealModel);
	}
	
	
	@PostMapping("/user/newrecipemeal/{idrecipe}")
	@Operation(summary = "Crear una comida con receta (desayuno,almuerzo,cena)" , description = " ... ")
	public ResponseEntity<?> newRecipeMeal(@PathVariable(name="idrecipe",required = true) long idrecipe) throws ParseException{
		MealModel mealModel = new MealModel();
		LocalDateTime localDateTime = LocalDateTime.now();
	    ZoneId zoneId = ZoneId.systemDefault();
	    Instant instant = localDateTime.atZone(zoneId).toInstant();
	    Date date = Date.from(instant);

	    mealModel.setIdUser(userService.getUserId());
	    mealModel.setDate(date);
		mealModel.setIdRecipe(idrecipe);
		Meal mealEntity = mealService.transform(mealModel);
	    mealRepository.save(mealEntity);
	    mealModel.setId(mealEntity.getId());
	    return ResponseEntity.status(HttpStatus.CREATED).body(mealModel);
		
	}


	
	//Borrar una comida realizada
	@DeleteMapping("/user/deletemeal/{idmeal}")
	@Operation(summary = "Borrar una comida realizada" , description = " ... ")
	public ResponseEntity<?> deleteMeal(@PathVariable (name="idmeal",required = true) long idmeal){
		boolean deleted = mealService.removeEntity(idmeal);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}
	
	//Traer todas las Meal de un usuario
	@GetMapping("/user/getallusermeal")
	@Operation(summary = "Traer todas las Meal de un usuario" , description = " ... ")
	public ResponseEntity<?> getAllMealByUserId(){
		List<Meal> allMeals = mealRepository.findAllByUserId(userService.getUserId());
		List<MealModel> allMealsModel = new ArrayList<>();
		for(Meal x : allMeals) {
			allMealsModel.add(mealService.transformToModel(x));
		}
		return ResponseEntity.status(HttpStatus.CREATED).body(allMealsModel);
	}
	
	//Traer la meal con esa id
	@GetMapping("/user/getmealbyid/{idmeal}")
	@Operation(summary = "Traer la meal con esa id" , description = " ... ")
	public ResponseEntity<?> getMealById(@PathVariable(name="idmeal", required = true) long idmeal){
		MealModel mealModel = mealService.findModelById(idmeal);
		return ResponseEntity.status(HttpStatus.CREATED).body(mealModel);
	}
	
	//Traer la meal correspondiende a ese date
	@GetMapping("/user/getmealbydate/{date}")
	public ResponseEntity<?> getMealByDate(@PathVariable("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {
		List<MealModel> meals = mealService.findMealByDate(date);
	    //if (meals != null && !meals.isEmpty()) {
	        List<MealModel> userMeals = meals.stream()
	                .filter(meal -> meal.getIdUser() == userService.getUserId())
	                .collect(Collectors.toList());
	        return ResponseEntity.ok(userMeals);
	    //}
	}

}
