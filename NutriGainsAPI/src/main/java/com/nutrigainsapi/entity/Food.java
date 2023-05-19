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
public class Food extends NutritionalData{
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@Column(name="barcode", unique = true, nullable = true)
	private Long barcode;
	@Column(name="name", unique = true, nullable = false)
	private String name;

	
	@OneToMany(cascade = CascadeType.ALL, mappedBy = "food",orphanRemoval = true)
	private List<RecipeList> recipes = new ArrayList<>();
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
	
	public Food() {
		super();
	}

	public Food(long id, Long barcode, String name,double kcal, double protein, double fat, double carbohydrates, 
			double sugar, double salt,  List<RecipeList> recipes, User user) {
		super(kcal, protein, fat, carbohydrates, sugar, salt);
		this.id = id;
		this.barcode = barcode;
		this.name = name;
		this.recipes = recipes;
		this.user = user;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public Long getBarcode() {
		return barcode;
	}

	public void setBarcode(Long barcode) {
		this.barcode = barcode;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
	
	
	

	

	


}
