package com.nutrigainsapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.RecipeList;
import com.nutrigainsapi.model.RecipeListModel;
import com.nutrigainsapi.service.GenericService;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api")
public class RestRecipeList {
	
	@Autowired
	@Qualifier("recipeListServiceImpl")
	private GenericService<RecipeList,RecipeListModel,Long> recipeListService;
	
	//Añadir alimentos a una receta
	@PostMapping("/user/foodtorecipe/{idrecipe}/{idfood}")
	@Operation(summary = "Añadir alimentos a una receta" , description = " ... ")
	public ResponseEntity<?> addFoodToRecipe(@PathVariable(name="idrecipe",required = true) long idrecipe,
			@PathVariable(name="idfood",required = true) long idfood){
		RecipeListModel recipeListModel = new RecipeListModel();
		recipeListModel.setIdRecipe(idrecipe);
		recipeListModel.setIdFood(idfood);
		recipeListService.addEntity(recipeListModel);
		return ResponseEntity.status(HttpStatus.CREATED).body(recipeListModel);	
	}
	
	
	//Borrar alimentos de una receta (que busque que coincidan el id recipe y el  id food)
	@DeleteMapping("/user/delfoodofrecipe/{idrecipe}/{idfood}")
	@Operation(summary = "Borrar alimentos de una receta" , description = " ... ")
	public ResponseEntity<?> deleteFoodOfRecipe(@PathVariable(name="idrecipe",required = true) long idrecipe,
			@PathVariable(name="idfood",required = true) long idfood){
		RecipeListModel food = new RecipeListModel();
		food = recipeListService.findModelById(null);
	return null;
	}
		

}
