package com.nutrigainsapi.model;

public class FoodModel {
	
	private long id;
	private String name;
	private double kcal;
	private double protein;
	private double fat;
	private double carbohydrates;
	private double sugar;
	private double salt;
	private long idUser;
	
	
	public FoodModel() {
		super();
	}


	public FoodModel(long id, String name, double kcal, double protein, double fat, double carbohydrates, double sugar,
			double salt, long idUser) {
		super();
		this.id = id;
		this.name = name;
		this.kcal = kcal;
		this.protein = protein;
		this.fat = fat;
		this.carbohydrates = carbohydrates;
		this.sugar = sugar;
		this.salt = salt;
		this.idUser = idUser;
	}


	public long getId() {
		return id;
	}


	public void setId(long id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public double getKcal() {
		return kcal;
	}


	public void setKcal(double kcal) {
		this.kcal = kcal;
	}


	public double getProtein() {
		return protein;
	}


	public void setProtein(double protein) {
		this.protein = protein;
	}


	public double getFat() {
		return fat;
	}


	public void setFat(double fat) {
		this.fat = fat;
	}


	public double getCarbohydrates() {
		return carbohydrates;
	}


	public void setCarbohydrates(double carbohydrates) {
		this.carbohydrates = carbohydrates;
	}


	public double getSugar() {
		return sugar;
	}


	public void setSugar(double sugar) {
		this.sugar = sugar;
	}


	public double getSalt() {
		return salt;
	}


	public void setSalt(double salt) {
		this.salt = salt;
	}


	public long getIdUser() {
		return idUser;
	}


	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}


	@Override
	public String toString() {
		return "FoodModel [id=" + id + ", name=" + name + ", kcal=" + kcal + ", protein=" + protein + ", fat=" + fat
				+ ", carbohydrates=" + carbohydrates + ", sugar=" + sugar + ", salt=" + salt + ", idUser=" + idUser
				+ "]";
	}
	
	
	
	
}
