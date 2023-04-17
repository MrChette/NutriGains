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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
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
	
	//Actualizar un comentario
	@PutMapping("/user/editcomment/{idcomment}")
	public ResponseEntity<?> editComment(@PathVariable(name="idcomment", required = true) long idcomment,
			@RequestBody CommentModel commentModel){
		boolean exist = commentService.findEntityById(idcomment)!=null;
		if(exist) {
			CommentModel cm = commentService.findModelById(idcomment);
			cm.setComment(commentModel.getComment());
			commentService.updateEntity(cm);
			return ResponseEntity.ok(cm);
		}
		else
			return ResponseEntity.noContent().build();
	}
	
	//Borrar un comentario
	@DeleteMapping("/user/deletecomment/{idcomment}")
	public ResponseEntity<?> deleteComment(@PathVariable(name="idcomment", required = true) long idcomment){
		boolean deleted = commentService.removeEntity(idcomment);
		if(deleted)
			return ResponseEntity.ok().build();
		else
			return ResponseEntity.noContent().build();
		
	}
	
	//Recupera todos los comentarios de una receta
	@GetMapping("/user/commentbyidrecipe/{idrecipe}")
	public ResponseEntity<?> getAllComments(@PathVariable(name="idrecipe", required = true) long idrecipe){
		boolean exist = commentService.listAll()!=null;
		if(exist) {
			List<CommentModel> modelList = commentService.listAll();
			List<CommentModel> comments = new ArrayList<>();
			for (CommentModel model : modelList) {
				if(model.getIdRecipe()==idrecipe) {
					comments.add(model);
				}
			}
			return ResponseEntity.ok(comments);
		}
		else
			return ResponseEntity.noContent().build();		
	}

}
