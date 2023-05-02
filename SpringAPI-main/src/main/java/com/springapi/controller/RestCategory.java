	package com.springapi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.springapi.model.CategoryModel;
import com.springapi.repository.CategoryRepository;
import com.springapi.service.CategoryService;
import com.springapi.service.ProductService;

@RestController
@RequestMapping("/api")
public class RestCategory {
	
	@Autowired
	@Qualifier("categoryServiceImpl")
	private CategoryService categoryService;
	
	@Autowired
	@Qualifier("productServiceImpl")
	private ProductService productService;
	
	@Autowired
	@Qualifier("categoryRepository")
	private CategoryRepository categoryRepository;
	

	//Crea una nueva categoría
	@PostMapping("/admin/categories")
	public ResponseEntity<?> createCategory(@RequestBody CategoryModel category) {
			categoryService.addCategory(category);
		return ResponseEntity.status(HttpStatus.CREATED).body(category);
	}
		
	
	//Actualiza una categoría si existe
	@PutMapping("/admin/categories/{id}")
	public ResponseEntity<?> updateCategory(@PathVariable(name = "id", required = true) long id,@RequestBody CategoryModel category) {
		boolean exist = categoryRepository.findById(id)!=null;
		if(exist) {
			category.setId(id);
			categoryService.updateCategory(category);
			return ResponseEntity.ok(category);
		}
		else
			return ResponseEntity.noContent().build();
		
	}
	
	//Recupera la categoría correspondiente a ese id
	@GetMapping("/admin/categories/{id}")
	public ResponseEntity<?> listCategory(@PathVariable(name = "id", required = true) long id) {
		boolean exist = categoryService.findCategoryById(id)!=null;
		if(exist) {
			CategoryModel categoryM = categoryService.findCategoryByIdModel(id);
			return ResponseEntity.ok(categoryM);
		}
		else
			return ResponseEntity.noContent().build();
		
	}
	
	
	
	//Elimina todos los productos de una determinada categoría
	@DeleteMapping("/admin/categories/{id}/products")
	public ResponseEntity<?> deleteProductByCategory(@PathVariable long id) {
		boolean deleted = productService.removeProductsInCategory(id);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
		
	}
	
	//Elimina una categoría y todos sus productos (categoría correspondiente a ese id)
	@DeleteMapping("/admin/categories/{id}")
	public ResponseEntity<?> deleteProduct(@PathVariable long id) {
		
		boolean deleted = categoryService.removeCategory(id);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
	}
	
	@GetMapping("/all/categories")
	public ResponseEntity<?> getCategories() {
		boolean exist = categoryService.listAllCategories()!=null;
		if(exist) {
			List<CategoryModel> category=categoryService.listAllCategories();
			return ResponseEntity.ok(category);
		}
		else
			return ResponseEntity.noContent().build();

	}
}
