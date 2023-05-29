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
	
	@Column(name="name", unique = false, nullable = false)
    private String name;

    @ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
    
    @Column(name = "bepublic", nullable = false)
    private int bePublic;
    
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "recipe",orphanRemoval = true)
	private List<RecipeList> recipes = new ArrayList<>();


	public Recipe() {
		super();
	}
	
	

	public Recipe(double kcal, double protein, double fat, double carbohydrates, double sugar, double salt, long id,
			String name, User user, List<RecipeList> recipes) {
		super(kcal, protein, fat, carbohydrates, sugar, salt);
		this.id = id;
		this.name = name;
		this.user = user;
		this.bePublic = 1;
		this.recipes = recipes;
	}


	




	public int getBePublic() {
		return bePublic;
	}



	public void setBePublic(int bePublic) {
		this.bePublic = bePublic;
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



    