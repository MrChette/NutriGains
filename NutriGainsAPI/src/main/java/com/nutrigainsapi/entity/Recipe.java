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
public class Recipe {
	@Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name="id")
    private long id;
	
	@Column(name="name", unique = true, nullable = false)
    private String name;
	
	@ManyToOne
	@JoinColumn(name = "food_id", nullable = false)
	private Food food;

    @ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
    

	public Recipe() {
		super();
	}


	public Recipe(long id, String name, Food food, User user) {
		super();
		this.id = id;
		this.name = name;
		this.food = food;
		this.user = user;
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


	public Food getFood() {
		return food;
	}


	public void setFood(Food food) {
		this.food = food;
	}


	public User getUser() {
		return user;
	}


	public void setUser(User user) {
		this.user = user;
	}


	@Override
	public String toString() {
		return "Recipe [id=" + id + ", name=" + name + ", food=" + food + ", user=" + user + "]";
	}

	
	

	

}



    