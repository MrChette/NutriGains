package com.nutrigainsapi.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;


@Entity
public class MealList {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@ManyToOne
	@JoinColumn(name = "recipe_id", nullable = true)
	private Recipe recipe;
	
	@ManyToOne
	@JoinColumn(name = "food_id", nullable = true)
	private Food food;
	
	@ManyToOne
	@JoinColumn(name = "meal_id", nullable = false)
	private Meal meal;

	public MealList() {
		super();
	}

	public MealList(long id, Recipe recipe, Food food, Meal meal) {
		super();
		this.id = id;
		this.recipe = recipe;
		this.food = food;
		this.meal = meal;
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

	public Meal getMeal() {
		return meal;
	}

	public void setMeal(Meal meal) {
		this.meal = meal;
	}

	@Override
	public String toString() {
		return "MealList [id=" + id + ", recipe=" + recipe + ", food=" + food + ", meal=" + meal + "]";
	}

	
	

}
