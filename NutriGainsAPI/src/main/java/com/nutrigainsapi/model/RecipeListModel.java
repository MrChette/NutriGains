package com.nutrigainsapi.model;

public class RecipeListModel {
	
	private long id;
	private long idRecipe;
	private long idFood;
	private long grams;
	
	public RecipeListModel() {
		super();
	}

	

	public RecipeListModel(long id, long idRecipe, long idFood, long grams) {
		super();
		this.id = id;
		this.idRecipe = idRecipe;
		this.idFood = idFood;
		this.grams = grams;
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



	@Override
	public String toString() {
		return "RecipeListModel [id=" + id + ", idRecipe=" + idRecipe + ", idFood=" + idFood + ", grams=" + grams + "]";
	}

	
	
	
	
}
