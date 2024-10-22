package com.nutrigainsapi.entity;
import java.util.Date;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

import com.fasterxml.jackson.annotation.JsonProperty;


@Entity
public class Meal {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "id")
	private long id;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "date", unique = false, nullable = false, columnDefinition = "DATE")
	private Date date;

	@Column(name = "grams", nullable = true)
	private Long grams;

	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	@ManyToOne
	@JoinColumn(name = "recipe_id", nullable = true)
	private Recipe recipe;

	@ManyToOne
	@JoinColumn(name = "food_id", nullable = true)
	private Food food;

	public Meal() {
		super();
	}

	public Meal(long id, Date date, Long grams, User user, Recipe recipe, Food food) {
		super();
		this.id = id;
		this.date = date;
		this.grams = grams;
		this.user = user;
		this.recipe = recipe;
		this.food = food;
	}

	public Long getGrams() {
		return grams;
	}

	@JsonProperty("id")
	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	@JsonProperty("date")
	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	@JsonProperty("user")
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@JsonProperty("recipe")
	public Recipe getRecipe() {
		return recipe;
	}

	public void setRecipe(Recipe recipe) {
		this.recipe = recipe;
	}

	@JsonProperty("food")
	public Food getFood() {
		return food;
	}

	public void setFood(Food food) {
		this.food = food;
	}
	
	

	public void setGrams(Long grams) {
		this.grams = grams;
	}

	@Override
	public String toString() {
		return "Meal [id=" + id + ", date=" + date + ", grams=" + grams + ", user=" + user + ", recipe=" + recipe
				+ ", food=" + food + "]";
	}

}
