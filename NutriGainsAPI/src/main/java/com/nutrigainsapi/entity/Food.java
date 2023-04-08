package com.nutrigainsapi.entity;

import java.util.ArrayList;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;


@Entity
public class Food {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@Column(name="barcode", unique = true, nullable = true)
	private long barcode;
	@Column(name="name", unique = true, nullable = false)
	private String name;
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
	
	@OneToMany(cascade = CascadeType.ALL, mappedBy = "food")
	private List<RecipeList> recipes = new ArrayList<>();
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
	
	public Food() {
		super();
	}

	public Food(long id, long barcode, String name, double kcal, double protein, double fat, double carbohydrates,
			double sugar, double salt, List<RecipeList> recipes, User user) {
		super();
		this.id = id;
		this.barcode = barcode;
		this.name = name;
		this.kcal = kcal;
		this.protein = protein;
		this.fat = fat;
		this.carbohydrates = carbohydrates;
		this.sugar = sugar;
		this.salt = salt;
		this.recipes = recipes;
		this.user = user;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getBarcode() {
		return barcode;
	}

	public void setBarcode(long barcode) {
		this.barcode = barcode;
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

	public List<RecipeList> getRecipes() {
		return recipes;
	}

	public void setRecipes(List<RecipeList> recipes) {
		this.recipes = recipes;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Food [id=" + id + ", barcode=" + barcode + ", name=" + name + ", kcal=" + kcal + ", protein=" + protein
				+ ", fat=" + fat + ", carbohydrates=" + carbohydrates + ", sugar=" + sugar + ", salt=" + salt
				+ ", recipes=" + recipes + ", user=" + user + "]";
	}

	


}
