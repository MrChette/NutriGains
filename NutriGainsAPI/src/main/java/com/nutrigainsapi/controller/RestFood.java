package com.nutrigainsapi.controller;

import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

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
		System.out.println(foodModel);
		foodService.addEntity(foodModel);
		return ResponseEntity.status(HttpStatus.CREATED).body(foodModel);
	}
	
	//Actualizar alimento
	@PutMapping("/user/editfood/{idfood}")
	public ResponseEntity<?> editFood(@PathVariable(name="idfood",required = true)long idfood,
			@RequestBody FoodModel foodModel){
		boolean exist = foodService.findEntityById(idfood)!=null;
		if(exist) {
			FoodModel fm = foodService.findModelById(idfood);
			
			Class<?> claseObjeto2 = foodModel.getClass();
			Set<String> camposExcluidos = new HashSet<>(Arrays.asList("id", "idUser"));
			Field[] campos = claseObjeto2.getDeclaredFields();
			for (Field campo : campos) {
			    campo.setAccessible(true);
			    if (!camposExcluidos.contains(campo.getName())) {
			        try {
			            Object valor = campo.get(foodModel);
			            campo.set(fm, valor);
			        } catch (IllegalAccessException e) {
			            e.printStackTrace();
			        }
			    }
			}
			
			foodService.updateEntity(fm);
			return ResponseEntity.ok(fm);
		}
		else
			return ResponseEntity.noContent().build();
	}
	
	//Eliminar alimento
	@DeleteMapping("/user/deletefood/{idfood}")
	public ResponseEntity<?> deleteFood(@PathVariable long idfood){
		boolean deleted = foodService.removeEntity(idfood);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}


}
