package com.nutrigainsapi.controller;

import java.text.ParseException;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.model.MealModel;
import com.nutrigainsapi.model.RecipeModel;
import com.nutrigainsapi.repository.MealRepository;
import com.nutrigainsapi.serviceImpl.FoodServiceImpl;
import com.nutrigainsapi.serviceImpl.MealServiceImpl;
import com.nutrigainsapi.serviceImpl.RecipeServiceImpl;
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
	
	@Autowired
	@Qualifier("foodServiceImpl")
	private FoodServiceImpl foodService;
	
	@Autowired
	@Qualifier("recipeServiceImpl")
	private RecipeServiceImpl recipeService;
	
	
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
	
	@PostMapping("/user/newfoodmeal")
	@Operation(summary = "Crear una comida (desayuno, almuerzo, cena)", description = "...")
	public ResponseEntity<?> newFoodMeal(@RequestParam List<Long> foodId,
											@RequestParam List<Long> grams){
	
		System.out.println("Watafak");
	    // Obtiene la fecha actual
	    LocalDateTime localDateTime = LocalDateTime.now();
	    ZoneId zoneId = ZoneId.systemDefault();
	    Instant instant = localDateTime.atZone(zoneId).toInstant();
	    Date date = Date.from(instant);

	    // Crea una lista para almacenar los modelos de comidas
	    List<MealModel> mealModels = new ArrayList<>();

	    // Itera sobre los objetos FoodMeal y los valores de gramos para crear los modelos de comidas
	    for (int i = 0; i < foodId.size(); i++) {

	        MealModel mealModel = new MealModel();
	        mealModel.setIdUser(userService.getUserId());
	        mealModel.setDate(date);
	        mealModel.setIdFood(foodId.get(i));
	        mealModel.setGrams(grams.get(i));

	        mealModels.add(mealModel);
	    }

	    // Transforma los modelos de comidas en entidades Meal y guárdalas en la base de datos
	    List<Meal> mealEntities = mealService.transformList(mealModels);
	    mealRepository.saveAll(mealEntities);


	    return ResponseEntity.status(HttpStatus.CREATED).body(mealModels);
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
		return ResponseEntity.ok(mealModel);
	}
	
	@GetMapping("/user/getmealbydate/{date}")
	public List<MealModel> getMealByDate(@PathVariable("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) {
	    List<MealModel> meals = mealService.findMealByDate(date);
	    if (meals.isEmpty()) {
	        // No se encontraron comidas para la fecha especificada
	        return Collections.emptyList();
	    }

	    long userId = userService.getUserId();

	    List<MealModel> userMeals = meals.stream()
	            .filter(meal -> meal.getIdUser() == userId)
	            .collect(Collectors.toList());

	    return userMeals;
	}
	
	
	@GetMapping("/user/gettodaykcal/{date}")
	public ResponseEntity<?> getTodayKcal(@PathVariable("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date date) throws ExecutionException {
	    List<MealModel> meals = mealService.findMealByDate(date);

	    final double[] kcal = {0};
	    final double[] protein = {0};
	    final double[] carbohydrates = {0};
	    final double[] fat = {0};

	    ExecutorService executorService = Executors.newFixedThreadPool(meals.size());
	    List<Future<Void>> futures = new ArrayList<>();

	    for (MealModel m : meals) {
	        futures.add(executorService.submit(() -> {
	            if (m.getIdFood() != null) {
	                FoodModel food = foodService.findModelById(m.getIdFood());
	                kcal[0] += ((m.getGrams() / 100) * food.getKcal());
	                protein[0] += ((m.getGrams() / 100) * food.getProtein());
	                carbohydrates[0] += ((m.getGrams() / 100) * food.getCarbohydrates());
	                fat[0] += ((m.getGrams() / 100) * food.getFat());
	            } else {
	                RecipeModel recipe = recipeService.findModelById(m.getIdRecipe());
	                kcal[0] += recipe.getKcal();
	                protein[0] += recipe.getProtein();
	                carbohydrates[0] += recipe.getCarbohydrates();
	                fat[0] += recipe.getFat();
	            }
	            return null;
	        }));
	    }

	    for (Future<Void> future : futures) {
	        try {
	            future.get();
	        } catch (InterruptedException e) {
	            e.printStackTrace();
	        }
	    }

	    executorService.shutdown();

	    List<Double> nutriments = new ArrayList<>();
	    nutriments.add(kcal[0]);
	    nutriments.add(protein[0]);
	    nutriments.add(carbohydrates[0]);
	    nutriments.add(fat[0]);

	    return ResponseEntity.ok(nutriments);
	}


}
