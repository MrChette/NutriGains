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
	@Column(name="foods_id", unique=false, nullable = false)
    private List<Long> food_Id;

    @ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;
    

	public Recipe() {
		super();
	}

	public Recipe(long id, String name, List<Long> food_Id, User user) {
		super();
		this.id = id;
		this.name = name;
		this.food_Id = food_Id;
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

	public List<Long> getFood_Id() {
		return food_Id;
	}

	public void setFood_Id(List<Long> food_Id) {
		this.food_Id = food_Id;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Recipe [id=" + id + ", name=" + name + ", food_Id=" + food_Id + ", user=" + user + "]";
	}
	
	

	

}



    