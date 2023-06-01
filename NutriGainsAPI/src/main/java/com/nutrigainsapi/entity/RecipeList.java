package com.nutrigainsapi.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

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
	
	@Column(name="grams")
	private long grams;
	
	@ManyToOne
	@JoinColumn(name = "recipe_id", nullable = false)
	@JsonIgnore
	private Recipe recipe;
	
	@ManyToOne
	@JoinColumn(name = "food_id", nullable = false)
	private Food food;
	
	
	

	public RecipeList() {
		super();
	}


	


	public RecipeList(long id, long grams, Recipe recipe, Food food) {
		super();
		this.id = id;
		this.grams = grams;
		this.recipe = recipe;
		this.food = food;
	}





	public long getGrams() {
		return grams;
	}





	public void setGrams(long grams) {
		this.grams = grams;
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
		return "RecipeList [id=" + id + ", grams=" + grams + ", recipe=" + recipe + ", food=" + food + "]";
	}




	
	
	
	
	
}
