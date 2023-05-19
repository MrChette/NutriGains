package com.nutrigainsapi.model;

public class NutritionalDataModel {
	private double kcal;
	private double protein;
	private double fat;
	private double carbohydrates;
	private double sugar;
	private double salt;
	
	
	
	public NutritionalDataModel() {
		super();
	}
	public NutritionalDataModel(double kcal, double protein, double fat, double carbohydrates, double sugar,
			double salt) {
		super();
		this.kcal = kcal;
		this.protein = protein;
		this.fat = fat;
		this.carbohydrates = carbohydrates;
		this.sugar = sugar;
		this.salt = salt;
	}
	
	
	public double getFat() {
		return fat;
	}
	public void setFat(double fat) {
		this.fat = fat;
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
	@Override
	public String toString() {
		return "NutritionalDataModel [kcal=" + kcal + ", protein=" + protein + ", fat=" + fat + ", carbohydrates="
				+ carbohydrates + ", sugar=" + sugar + ", salt=" + salt + "]";
	}
	
	

}
