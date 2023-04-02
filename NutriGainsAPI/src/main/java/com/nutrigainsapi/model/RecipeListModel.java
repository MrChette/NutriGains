package com.nutrigainsapi.model;

public class RecipeListModel {
	
	private long id;
	private long idRecipe;
	private long idFood;
	
	public RecipeListModel() {
		super();
	}

	public RecipeListModel(long id, long idRecipe, long idFood) {
		super();
		this.id = id;
		this.idRecipe = idRecipe;
		this.idFood = idFood;
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
		return "RecipeListModel [id=" + id + ", idRecipe=" + idRecipe + ", idFood=" + idFood + "]";
	}
	
	
	
}
