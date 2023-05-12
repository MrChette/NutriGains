package com.nutrigainsapi.entity;

import java.util.ArrayList;
import java.util.Date;
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
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;


@Entity
public class Meal {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name="date", unique=false, nullable = false,columnDefinition = "DATE")
	private Date date;
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	
	@OneToMany(cascade = CascadeType.ALL, mappedBy = "meal",orphanRemoval = true)
	private List<MealList> recipes = new ArrayList<>();
	
	

	public Meal() {
		super();
	}



	public Meal(long id, Date date, User user, List<MealList> recipes) {
		super();
		this.id = id;
		this.date = date;
		this.user = user;
		this.recipes = recipes;
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



	public User getUser() {
		return user;
	}



	public void setUser(User user) {
		this.user = user;
	}



	public List<MealList> getRecipes() {
		return recipes;
	}



	public void setRecipes(List<MealList> recipes) {
		this.recipes = recipes;
	}



	
	
	
	
	

}
