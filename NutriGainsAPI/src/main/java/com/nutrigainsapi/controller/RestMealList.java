//package com.nutrigainsapi.controller;
//
//import java.util.ArrayList;
//import java.util.List;
//
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.PathVariable;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//
//import com.nutrigainsapi.entity.MealList;
//import com.nutrigainsapi.model.MealListModel;
//import com.nutrigainsapi.repository.MealListRepository;
//import com.nutrigainsapi.service.GenericService;
//
//import io.swagger.v3.oas.annotations.Operation;
//
//@RestController
//@RequestMapping("/api")
//public class RestMealList {
//	
//	@Autowired
//	@Qualifier("mealListServiceImpl")
//	private GenericService<MealList,MealListModel,Long> mealListService;
//	
//	@Autowired
//	@Qualifier("mealListRepository")
//	private MealListRepository mealListRepository;
//	
//	
//	//Añadir alimentos a las comidas realizadas
//	@PostMapping("/user/foodtomeal/{idmeal}/{idfood}")
//	@Operation(summary = "Añadir alimentos a las comidas realizadas" , description = " ... ")
//	public ResponseEntity<?> addFoodToMeal(@PathVariable(name="idmeal",required = true) long idmeal,
//			@PathVariable(name="idfood",required = true) long idfood) {
//		MealListModel mealListModel = new MealListModel();
//		
//		mealListModel.setIdMeal(idmeal);
//		mealListModel.setIdFood(idfood);
//		mealListService.addEntity(mealListModel);
//		
//		return ResponseEntity.status(HttpStatus.CREATED).body(mealListModel);
//	}
//	
//	
//	//Añadir recetas a las comidas realizadas
//	@PostMapping("/user/recipetomeal/{idmeal}/{idrecipe}")
//	@Operation(summary = "Añadir recetas a las comidas realizadas" , description = " ... ")
//	public ResponseEntity<?> addRecipeToMeal(@PathVariable(name="idmeal",required = true) long idmeal,
//			@PathVariable(name="idrecipe",required = true) long idrecipe) {
//		MealListModel mealListModel = new MealListModel();
//		
//		mealListModel.setIdMeal(idmeal);
//		mealListModel.setIdRecipe(idrecipe);
//		mealListService.addEntity(mealListModel);
//		
//		return ResponseEntity.status(HttpStatus.CREATED).body(mealListModel);
//	}
//	
//	//Traer todas las MealList de un Meal (idmeal)
//	@GetMapping("user/getmeallistbyidmeal/{idmeal}")
//	@Operation(summary = "Traer todas las MealList de un Meal (idmeal)" , description = " ... ")
//	public ResponseEntity<?> getMealsByIdMeal(@PathVariable(name="idmeal", required= true) long idmeal){
//			List<MealList> mealList = mealListRepository.findAllByMealId(idmeal);
//			System.out.println(mealList);
//			List<MealListModel> mealListModel = new ArrayList<>() ;
//			for(MealList x : mealList) {
//				System.out.println(x);
//				mealListModel.add(mealListService.transformToModel(x));
//			}
//		return ResponseEntity.status(HttpStatus.CREATED).body(mealListModel);
//	}
//	
//	
//
//}
