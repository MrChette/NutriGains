package com.nutrigainsapi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.nutrigainsapi.entity.Comment;
import com.nutrigainsapi.model.CommentModel;
import com.nutrigainsapi.service.GenericService;

@RestController
@RequestMapping("/api")
public class RestComment {
	
	@Autowired
	@Qualifier("commentServiceImpl")
	private GenericService<Comment,CommentModel,Long> commentService;
	
	
	//Crear comentarios para una receta
	@PostMapping("/user/newcomment/{iduser}/{idrecipe}")
	public ResponseEntity<?> newComment(@PathVariable(name="iduser", required = true)long iduser,
			@PathVariable(name="idrecipe", required = true) long idrecipe,
			@RequestBody CommentModel commentModel){
		commentModel.setIdRecipe(idrecipe);
		commentModel.setIdUser(iduser);
		commentService.addEntity(commentModel);
		return ResponseEntity.status(HttpStatus.CREATED).body(commentModel);

		
				
	}

}
