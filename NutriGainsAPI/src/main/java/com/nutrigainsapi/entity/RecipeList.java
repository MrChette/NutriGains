package com.nutrigainsapi.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;

@Entity
public class RecipeList {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="id")
    private long id;
	
	@ManyToOne
	@JoinColumn(name = "recipe_id", nullable = false)
	private Recipe recipe;
	
	@ManyToOne
	@JoinColumn(name = "food_id", nullable = false)
	private Food food;
	
	
	

	public RecipeList() {
		super();
	}


	public RecipeList(long id, Recipe recipe, Food food) {
		super();
		this.id = id;
		this.recipe = recipe;
		this.food = food;
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




	public Food getFood() {
		return food;
	}




	public void setFood(Food food) {
		this.food = food;
	}




	@Override
	public String toString() {
		return "RecipeList [id=" + id + ", recipe=" + recipe + ", food=" + food + "]";
	}
	
	
	
	
}
