package com.nutrigainsapi.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.entity.Recipe;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.model.RecipeModel;
import com.nutrigainsapi.repository.RecipeRepository;
import com.nutrigainsapi.service.GenericService;
import com.nutrigainsapi.serviceImpl.UserService;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api")
public class RestRecipe {
	
	@Autowired
	@Qualifier("recipeServiceImpl")
	private GenericService<Recipe,RecipeModel,Long> recipeService;
	
	@Autowired
	@Qualifier("recipeRepository")
	private RecipeRepository recipeRepository;
	
	@Autowired
	@Qualifier("userService")
	private UserService userService;
	

	public ResponseEntity<Recipe> createBaseRecipe(RecipeModel recipeModel){
		System.out.println("Rest " + recipeModel);
		recipeService.addEntity(recipeModel);
	return ResponseEntity.ok(recipeService.transform(recipeModel));
	}
	
	//Actualizar una receta (solo tiene nombre)
	@PutMapping("/user/editrecipe/{idrecipe}")
	@Operation(summary = "Actualizar una receta (solo tiene nombre)" , description = " ... ")
	public ResponseEntity<?> editRecipe(@PathVariable(name="idrecipe",required=true) long idrecipe,
			@RequestBody RecipeModel recipemodel){
		boolean exist = recipeService.findEntityById(idrecipe)!=null;
		if(exist) {
			RecipeModel rp = recipeService.findModelById(idrecipe);
			rp.setName(recipemodel.getName());
			recipeService.updateEntity(rp);
			return ResponseEntity.ok(rp);
		}
		else
			return ResponseEntity.noContent().build();
	}
	
	@GetMapping("/user/getalluserrecipe")
	@Operation(summary = "Actualizar una receta (solo tiene nombre)" , description = " ... ")
	public ResponseEntity<?> getalluserrecipe() {
		
	 boolean exist = recipeRepository.findByUserId(userService.getUserId())!=null;

			
		if (exist) {
		List<Recipe> recipes = recipeRepository.findByUserId(userService.getUserId());
		
		List<RecipeModel> modelRecipes = new ArrayList<>();
		System.out.println("RECIPEMODEL");
		for(Recipe x : recipes) {;
			modelRecipes.add(recipeService.transformToModel(x));
		}
		return ResponseEntity.ok(modelRecipes);
		}
		else
			return ResponseEntity.noContent().build();
	}
	/*
	 * boolean exist = foodRepository.findByUserId(userService.getUserId())!=null;
		System.out.println(exist);
		if (exist) {
		List<Food> userFoods = foodRepository.findByUserId(userService.getUserId());
		for(Food x : userFoods)
			System.out.println(x.toString());
		
		List<FoodModel> modelFoods = new ArrayList<>();
		System.out.println("FOODMODEL");
		for(Food x : userFoods) {
			System.out.println(x.toString());
			modelFoods.add(foodService.transformToModel(x));
		}
		return ResponseEntity.ok(modelFoods);
		}
		else
			return ResponseEntity.noContent().build();
	 */
	
	@GetMapping("/user/getrecipe/{idmeal}")
	@Operation(summary = "Actualizar una receta (solo tiene nombre)" , description = " ... ")
	public ResponseEntity<?> getrecipe(@PathVariable(name="idmeal",required=true) long idmeal){
		boolean exist = recipeService.findEntityById(idmeal)!=null;
		if(exist) {
			RecipeModel rp = recipeService.findModelById(idmeal);
			return ResponseEntity.accepted().body(rp);
		}
		else
			return ResponseEntity.noContent().build();
	}
	
	
	//Borra una receta
	@DeleteMapping("/user/deleterecipe/{idrecipe}")
	@Operation(summary = "Borra una receta" , description = " ... ")
	public ResponseEntity<?> deleteRecipe(@PathVariable(name="idrecipe",required=true) long idrecipe){
		boolean deleted = recipeService.removeEntity(idrecipe);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}	
	

}
