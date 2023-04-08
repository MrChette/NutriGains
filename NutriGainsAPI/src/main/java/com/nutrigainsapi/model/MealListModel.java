package com.nutrigainsapi.model;

public class MealListModel {
	
	private long id;
	private Long idRecipe;
    private Long idFood;
	private long idMeal;
	
	public MealListModel() {
		super();
	}

	public MealListModel(long id, long idRecipe, long idFood, long idMeal) {
        this.id = id;
        this.idRecipe = (idRecipe == 0) ? null : idRecipe;
        this.idFood = (idFood == 0) ? null : idFood;
        this.idMeal = idMeal;
    }

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Long getIdRecipe() {
		return idRecipe;
	}

	public void setIdRecipe(Long idRecipe) {
		this.idRecipe = idRecipe;
	}

	public Long getIdFood() {
		return idFood;
	}

	public void setIdFood(Long idFood) {
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
