package com.nutrigainsapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Recipe;
import com.nutrigainsapi.model.RecipeModel;
import com.nutrigainsapi.service.GenericService;

@RestController
@RequestMapping("/api")
public class RestRecipe {
	
	@Autowired
	@Qualifier("recipeServiceImpl")
	private GenericService<Recipe,RecipeModel,Long> recipeService;
	
	//Crear una Receta Base
	@PostMapping("/user/{id}/newrecipe")
	public ResponseEntity<?> createBaseRecipe(@PathVariable (name="id", required = true) long id,
			@RequestBody RecipeModel recipeModel){
		recipeModel.setIdUser(id);
		recipeService.addEntity(recipeModel);
	return ResponseEntity.status(HttpStatus.CREATED).body(recipeModel);
	}
	
	//Actualizar una receta (solo tiene nombre)
	@PutMapping("/user/editrecipe/{idrecipe}")
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
	
	//Borra una receta
	@DeleteMapping("/user/deleterecipe/{idrecipe}")
	public ResponseEntity<?> deleteRecipe(@PathVariable(name="idrecipe",required=true) long idrecipe){
		boolean deleted = recipeService.removeEntity(idrecipe);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}
	
	

}
