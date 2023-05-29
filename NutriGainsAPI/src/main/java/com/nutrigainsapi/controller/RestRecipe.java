package com.nutrigainsapi.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Recipe;
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
	
	
	@GetMapping("/user/getallrecipes")
	@Operation(summary = "Recibe todas las recetas")
	public ResponseEntity<?> getAllRecipes() {
	    List<RecipeModel> allRecipes = recipeService.listAll();
	    
	    System.out.println(allRecipes);

	    List<RecipeModel> publicRecipes = allRecipes.stream()
	            .filter(recipe -> recipe.getBePublic()==1)
	            .collect(Collectors.toList());
	    
	    System.out.println(publicRecipes);

	    return ResponseEntity.ok().body(publicRecipes);
	}
	
	@GetMapping("/user/getrecipelist")
	@Operation(summary = "Recibe las recetas que tienen comentarios", description = " ... ")
	public ResponseEntity<?> getRecipe(@RequestParam(name = "idmeal") List<Long> idMeals) {
	    List<RecipeModel> recipeList = new ArrayList<>();

	    ExecutorService executor = Executors.newFixedThreadPool(idMeals.size());
	    List<Future<RecipeModel>> futures = new ArrayList<>();

	    for (Long idMeal : idMeals) {
	        Callable<RecipeModel> callable = () -> recipeService.findModelById(idMeal);
	        Future<RecipeModel> future = executor.submit(callable);
	        futures.add(future);
	    }
	    
	    executor.shutdown();


	    for (Future<RecipeModel> future : futures) {
	        try {
	            RecipeModel rp = future.get();
	            if (rp != null) {
	                recipeList.add(rp);
	            }
	        } catch (InterruptedException | ExecutionException e) {
	            e.printStackTrace();
	        }
	    }

	   
	    if (!recipeList.isEmpty()) {
	        return ResponseEntity.accepted().body(recipeList);
	    } else {
	        return ResponseEntity.noContent().build();
	    }
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
	
	@GetMapping("/user/externalrecipe/{idrecipe}")
	@Operation(summary = "Añade una receta que no ha creado el usuario añadiendola a la lista de recetas del usuario")
	public ResponseEntity<?> externalRecipe(@PathVariable(name="idrecipe", required = true) long idrecipe){
		Recipe recipe = recipeService.findEntityById(idrecipe);
		Long userId = userService.getUserId();
		if(recipe.getUser().getId() == userId) {
			return ResponseEntity.noContent().build();
		}else {
			System.out.println(recipe.getId());
			RecipeModel recipeModel = recipeService.transformToModel(recipe);
			recipeModel.setId(0);
			recipeModel.setBePublic(0);
			recipeModel.setIdUser(userId);
			System.out.println(recipeModel);
			recipeService.addEntity(recipeModel);
			return ResponseEntity.ok(recipeModel);
		}
	}
	

}
