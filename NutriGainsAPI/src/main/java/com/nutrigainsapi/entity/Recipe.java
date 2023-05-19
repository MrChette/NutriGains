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
public class Recipe extends NutritionalData {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="id")
    private long id;
	
	@Column(name="name", unique = true, nullable = false)
    private String name;

    @ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "recipe",orphanRemoval = true)
	private List<RecipeList> recipes = new ArrayList<>();


	public Recipe() {
		super();
	}
	
	public Recipe(long id, String name, double kcal, double protein, 
			double fat, double carbohydrates, double sugar, double salt,  List<RecipeList> recipes, User user) {
		super(kcal, protein, fat, carbohydrates, sugar, salt);
		this.id = id;
		this.name = name;
		this.user = user;
		this.recipes = recipes;
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

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public List<RecipeList> getRecipes() {
		return recipes;
	}

	public void setRecipes(List<RecipeList> recipes) {
		this.recipes = recipes;
	}

	@Override
	public String toString() {
		return "Recipe [id=" + id + ", name=" + name + ", user=" + user + ", recipes=" + recipes + ", getKcal()="
				+ getKcal() + ", getProtein()=" + getProtein() + ", getFat()=" + getFat() + ", getCarbohydrates()="
				+ getCarbohydrates() + ", getSugar()=" + getSugar() + ", getSalt()=" + getSalt() + ", toString()="
				+ super.toString() + ", getClass()=" + getClass() + ", hashCode()=" + hashCode() + "]";
	}


	





	

}



    