package com.nutrigainsapi.model;

import java.util.List;

public class MealModel {
	
	private long id;
	private long idRecipe;
	private List<Long> idFoodList;
	private long idUser;
	
	public MealModel() {
		super();
	}

	public MealModel(long id, long idRecipe, List<Long> idFoodList, long idUser) {
		super();
		this.id = id;
		this.idRecipe = idRecipe;
		this.idFoodList = idFoodList;
		this.idUser = idUser;
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

	public List<Long> getIdFoodList() {
		return idFoodList;
	}

	public void setIdFoodList(List<Long> idFoodList) {
		this.idFoodList = idFoodList;
	}

	public long getIdUser() {
		return idUser;
	}

	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}

	@Override
	public String toString() {
		return "MealModel [id=" + id + ", idRecipe=" + idRecipe + ", idFoodList=" + idFoodList + ", idUser=" + idUser
				+ "]";
	}
	
	
	
	

}
