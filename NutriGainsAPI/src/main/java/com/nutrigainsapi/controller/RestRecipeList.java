package com.nutrigainsapi.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Recipe;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.model.RecipeListModel;
import com.nutrigainsapi.model.RecipeModel;
import com.nutrigainsapi.serviceImpl.FoodServiceImpl;
import com.nutrigainsapi.serviceImpl.RecipeListServiceImpl;
import com.nutrigainsapi.serviceImpl.RecipeServiceImpl;
import com.nutrigainsapi.serviceImpl.UserService;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api")
public class RestRecipeList {
	
	
	
	@Autowired
	@Qualifier("userService")
	private UserService userService;
	
	
	@Autowired
	@Qualifier("recipeListServiceImpl")
	private RecipeListServiceImpl recipeListService;
	
	@Autowired
	@Qualifier("foodServiceImpl")
	private FoodServiceImpl foodService;
	
	@Autowired
	@Qualifier("recipeServiceImpl")
	private RecipeServiceImpl recipeService;
	
	//Añadir alimentos a una receta
	@PostMapping("/user/foodtorecipe")
	@Operation(summary = "Añadir alimentos a una receta", description = " ... ")
	public ResponseEntity<?> addFoodToRecipe(@RequestBody Map<String, Object> request) {
		List<String> idFoodStrings = (List<String>) request.get("idFood");
	    List<String> gramsStrings = (List<String>) request.get("grams");
	    String name = (String) request.get("name");

	    List<Long> idFoods = idFoodStrings.stream()
	                                      .map(Long::parseLong)
	                                      .collect(Collectors.toList());
	    System.out.println("IDFOODS -- " + idFoods);

	    List<Long> gramsList = gramsStrings.stream()
	                                       .map(Long::parseLong)
	                                       .collect(Collectors.toList());
	    
	    System.out.println("idfoods" + idFoods);
	    System.out.println(gramsList);
	    if (idFoods.size() != gramsList.size() || name == "") {
	    	return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
	    }
	  
	    RecipeModel recipeModel = new RecipeModel();
	    recipeModel.setName(name);
	    recipeModel.setIdUser(userService.getUserId());
	    recipeModel.setId(0);
	    recipeModel.setVisible(1);
	    recipeModel.setBePublic(1);
	    for (int i = 0; i < idFoods.size(); i++) {
	        Long idFood = idFoods.get(i);
	        long grams = gramsList.get(i);
	        System.out.println(idFood);
	        FoodModel food = foodService.findModelById(idFood);
	        recipeModel.setKcal(recipeModel.getKcal()+((food.getKcal()/100)*grams));
	        recipeModel.setProtein(recipeModel.getProtein()+((food.getProtein()/100)*grams));
	        recipeModel.setCarbohydrates(recipeModel.getCarbohydrates()+((food.getCarbohydrates()/100)*grams));
	        recipeModel.setFat(recipeModel.getFat()+((food.getFat()/100)*grams));
	        recipeModel.setSalt(recipeModel.getSalt()+((food.getSalt()/100)*grams));
	        recipeModel.setSugar(recipeModel.getSugar()+((food.getSalt()/100)*grams));
	        
	    }
	    System.out.println("RecipeModel " + recipeModel);
	    Recipe recipe = recipeService.addEntity(recipeModel);
	    
 
	    List<RecipeListModel> recipeList = new ArrayList<RecipeListModel>();
        for (int i = 0; i < idFoods.size(); i++) {
        	RecipeListModel recipeListModel = new RecipeListModel();
        	long idFood = idFoods.get(i);
	        long grams = gramsList.get(i);
	        recipeListModel.setIdRecipe(recipe.getId());
	        recipeListModel.setIdFood(idFood);
	        recipeListModel.setGrams(grams);
	        recipeList.add(recipeListModel);
        }
	    recipeListService.addEntities(recipeList);
	    
	    return ResponseEntity.status(HttpStatus.CREATED).body(recipeList);
	}
	
	
	
	//Borrar alimentos de una receta (que busque que coincidan el id recipe y el  id food)
//	@DeleteMapping("/user/delfoodofrecipe/{idrecipe}/{idfood}")
//	@Operation(summary = "Borrar alimentos de una receta" , description = " ... ")
//	public ResponseEntity<?> deleteFoodOfRecipe(@PathVariable(name="idrecipe",required = true) long idrecipe,
//			@PathVariable(name="idfood",required = true) long idfood){
//		RecipeListModel food = new RecipeListModel();
//		food = recipeListService.findModelById(null);
//	return ResponseEntity.ok(food);
//	}
//	
	
	@GetMapping("/user/getfoodsbyidrecipe/{idRecipe}")
	@Operation(summary= "Devuelve la lista de recipelist que contienen ese idRecipe")
	public ResponseEntity<?> getfoodsbyidrecipe(@PathVariable(name="idRecipe",required = true) long idrecipe) {
		List<RecipeListModel> recipeL = recipeListService.getListRecipesByRecipeId(idrecipe);
		for(RecipeListModel r : recipeL)
			System.out.println(r);
		
		if(!recipeL.isEmpty())
			return ResponseEntity.ok(recipeL);
		else
			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
		
	}
		

}
