package com.nutrigainsapi.entity;

import jakarta.persistence.Column;
import jakarta.persistence.MappedSuperclass;


@MappedSuperclass
public class NutritionalData {
	@Column(name="kcal", unique=false, nullable = false)
    private double kcal;
    @Column(name="protein", unique=false, nullable = false)
    private double protein;
    @Column(name="fat", unique=false, nullable = false)
    private double fat;
    @Column(name="carbohydrates", unique=false, nullable = false)
    private double carbohydrates;
    @Column(name="sugar", unique=false, nullable = false)
    private double sugar;
    @Column(name="salt", unique=false, nullable = false)
    private double salt;
    
    
    
    
	public NutritionalData() {
		super();
	}




	public NutritionalData(double kcal, double protein, double fat, double carbohydrates, double sugar, double salt) {
		super();
		this.kcal = kcal;
		this.protein = protein;
		this.fat = fat;
		this.carbohydrates = carbohydrates;
		this.sugar = sugar;
		this.salt = salt;
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




	@Override
	public String toString() {
		return "NutritionalData [kcal=" + kcal + ", protein=" + protein + ", fat=" + fat + ", carbohydrates="
				+ carbohydrates + ", sugar=" + sugar + ", salt=" + salt + "]";
	}
	
	
    
    
    
}




