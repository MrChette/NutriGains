package com.nutrigainsapi.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class Comment {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@ManyToOne
	@JoinColumn(name = "recipe_id", unique=false,nullable = false)
	private Recipe recipe;
	
	@ManyToOne
	@JoinColumn(name = "user_id", unique=false, nullable = false)
	private User user;
	
	@Column(name="comment",unique=false,nullable=false)
	private String comment;

	public Comment() {
		super();
	}

	public Comment(long id, Recipe recipe, User user, String comment) {
		super();
		this.id = id;
		this.recipe = recipe;
		this.user = user;
		this.comment = comment;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Recipe getRecipe() {
		return recipe;
	}

	public void setRecipe(Recipe recipe) {
		this.recipe = recipe;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	@Override
	public String toString() {
		return "Comment [id=" + id + ", recipe=" + recipe + ", user=" + user + ", comment=" + comment + "]";
	}

	
	

}
