package com.nutrigainsapi.model;

import java.util.Date;

public class MealModel {
	
	private long id;
	private Date date;
	private long idUser;
	private Long idFood;
	private Long idRecipe;
	private Long grams;
	
	public MealModel() {
		super();
	}
	
	
	public MealModel(long id, Date date, long idUser, Long idFood, Long idRecipe, Long grams) {
		super();
		this.id = id;
		this.date = date;
		this.idUser = idUser;
		this.idRecipe = (idRecipe == 0) ? null : idRecipe;
        this.idFood = (idFood == 0) ? null : idFood;
		this.grams = grams = (grams == 0) ? null : grams;;
	}



	public Long getGrams() {
		return grams;
	}


	public void setGrams(Long grams) {
		this.grams = grams;
	}


	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public long getIdUser() {
		return idUser;
	}

	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}

	public Long getIdFood() {
		return idFood;
	}

	public void setIdFood(Long idFood) {
		this.idFood = idFood;
	}

	public Long getIdRecipe() {
		return idRecipe;
	}

	public void setIdRecipe(Long idRecipe) {
		this.idRecipe = idRecipe;
	}


	@Override
	public String toString() {
		return "MealModel [id=" + id + ", date=" + date + ", idUser=" + idUser + ", idFood=" + idFood + ", idRecipe="
				+ idRecipe + ", grams=" + grams + "]";
	}

	

	

	
	
	
	
	

}
