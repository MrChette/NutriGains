package com.nutrigainsapi.model;

public class MealListModel {
	
	private long id;
	private long idRecipe;
	private long idFood;
	private long idMeal;
	
	public MealListModel() {
		super();
	}

	public MealListModel(long id, long idRecipe, long idFood, long idMeal) {
		super();
		this.id = id;
		this.idRecipe = idRecipe;
		this.idFood = idFood;
		this.idMeal = idMeal;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getIdRecipe() {
		return idRecipe;
	}

	public void setIdRecipe(long idRecipe) {
		this.idRecipe = idRecipe;
	}

	public long getIdFood() {
		return idFood;
	}

	public void setIdFood(long idFood) {
		this.idFood = idFood;
	}

	public long getIdMeal() {
		return idMeal;
	}

	public void setIdMeal(long idMeal) {
		this.idMeal = idMeal;
	}

	@Override
	public String toString() {
		return "MealListModel [id=" + id + ", idRecipe=" + idRecipe + ", idFood=" + idFood + ", idMeal=" + idMeal + "]";
	}
	
	
	
	

}
