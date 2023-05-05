package com.nutrigainsapi.controller;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.nutrigainsapi.apirest.Product;
import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.model.User;
import com.nutrigainsapi.repository.FoodRepository;
import com.nutrigainsapi.service.GenericService;
import com.nutrigainsapi.serviceImpl.UserService;

import io.swagger.v3.oas.annotations.Operation;

@RestController
@RequestMapping("/api")
public class RestFood {
	
	@Autowired
	@Qualifier("foodServiceImpl")
	private GenericService<Food,FoodModel,Long> foodService;
	
	@Autowired
	@Qualifier("foodRepository")
	private FoodRepository foodRepository;
	
	@Autowired
	@Qualifier("userService")
	private UserService userService;
	
	//Crear un alimento
	@PostMapping("/user/newfood")
	@Operation(summary = "Crear un alimento" , description = " ... ")
	public ResponseEntity<?> createFood(@RequestBody FoodModel foodModel){
		foodModel.setIdUser(userService.getUserId());
		System.out.println(foodModel);
		foodService.addEntity(foodModel);
		return ResponseEntity.status(HttpStatus.CREATED).body(foodModel);
	}
	
	//Actualizar alimento
	@PutMapping("/user/editfood/{idfood}")
	@Operation(summary = "Actualizar alimento" , description = " ... ")
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
	@Operation(summary = "Eliminar alimento" , description = " ... ")
	public ResponseEntity<?> deleteFood(@PathVariable long idfood){
		boolean deleted = foodService.removeEntity(idfood);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}
	
	//Traer todos los alimentos de un usuario
	@GetMapping("/user/getalluserfood")
	@Operation(summary = "Traer todos los alimentos de un usuario" , description = " ... ")
	public ResponseEntity<?> getFoodByUser(){
		boolean exist = foodRepository.findByUserId(userService.getUserId())!=null;
		if (exist) {
		List<Food> userFoods = foodRepository.findByUserId(userService.getUserId());
		List<FoodModel> modelFoods = new ArrayList<>();
		for(Food x : userFoods) {
			modelFoods.add(foodService.transformToModel(x));
		}
		return ResponseEntity.ok(modelFoods);
		}
		else
			return ResponseEntity.noContent().build();
		
	}
	
	//Comprobar si el alimento con ese codigo de barra existe en la bbdd
	@GetMapping("/user/getfoodbybarcode/{barcode}")
	@Operation(summary = "Comprobar si el alimento con ese codigo de barra existe en la bbdd" , description = " ... ")
	public ResponseEntity<?> getFoodByBarCode(@PathVariable(name="barcode",required = true) long barcode){
		boolean exist = foodRepository.findByBarcode(barcode)!=null;
		if (exist) {
			FoodModel food = foodService.transformToModel(foodRepository.findByBarcode(barcode));
			return ResponseEntity.ok(food);
		}
		else
			return ResponseEntity.noContent().build();
		}
		
		
		//Peticion get API OpenFoodFacts by BARCODE
		@GetMapping("/user/foodbyapi/{barcode}")
		@Operation(summary = "Peticion get API OpenFoodFacts by BARCODE y lo añade a la BBDD" , description = " ... ")
		public ResponseEntity<?> foodbyapi(@PathVariable(name="barcode",required = true) long barcode) throws JsonMappingException, JsonProcessingException{
			
			ResponseEntity<?> response = getFoodByBarCode(barcode);
			if(response.getStatusCodeValue()==204) {
				RestTemplate restTemplate = new RestTemplate();
				String apiUrl = "https://world.openfoodfacts.net/api/v2/product/"+barcode+"?fields=product_name,nutriments";
				String credentials = "off:off";
				String encodedCredentials = new String(Base64.getEncoder().encode(credentials.getBytes()));
				HttpHeaders headers = new HttpHeaders();
				headers.add("Authorization", "Basic " + encodedCredentials);
				HttpEntity<String> entity = new HttpEntity<>(headers);
				
				Product product = restTemplate.exchange(apiUrl, HttpMethod.GET, entity, Product.class).getBody();
				System.out.println(product.toString());
				FoodModel food = new FoodModel();
					food.setBarcode(Long.parseLong(product.getCode()));
					food.setName(product.getProduct().getProduct_name());
					food.setKcal(product.getProduct().getNutriments().getEnergykcal());
					food.setProtein(product.getProduct().getNutriments().getProteins());
					food.setFat(product.getProduct().getNutriments().getFat());
					food.setCarbohydrates(product.getProduct().getNutriments().getCarbohydrates());
					food.setSugar(product.getProduct().getNutriments().getSugars());
					food.setSalt(product.getProduct().getNutriments().getSalt());
					food.setIdUser(userService.getUserId());
				foodService.addEntity(food);
				
				return ResponseEntity.ok(food);
			}
			else
				return ResponseEntity.noContent().build();		
		}
		
}
      