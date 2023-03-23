package com.nutrigainsapi.entity;

import java.sql.Date;
import java.util.List;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;


@Entity
public class Meal {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	@Column(name="id")
	private long id;
	
	@Column(name="idRecipe", unique=false, nullable = true)
	private long idRecipe;
	
	@Column(name="idFood_list", unique=false, nullable = true)
	private List<Long> idFoodList;
	
	@Column(name="date", unique=false, nullable = false)
	private Date date;
	
	@ManyToOne
	@JoinColumn(name = "user_id", nullable = false)
	private User user;

	public Meal() {
		super();
	}

	public Meal(long id, long idRecipe, List<Long> idFoodList, Date date, User user) {
		super();
		this.id = id;
		this.idRecipe = idRecipe;
		this.idFoodList = idFoodList;
		this.date = date;
		this.user = user;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getIdRecipe() {
		return idRecipe;
	}

	public void setIdRecipe(long idRecipe) {
		this.idRecipe = idRecipe;
	}

	public List<Long> getIdFoodList() {
		return idFoodList;
	}

	public void setIdFoodList(List<Long> idFoodList) {
		this.idFoodList = idFoodList;
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

	@Override
	public String toString() {
		return "Meal [id=" + id + ", idRecipe=" + idRecipe + ", idFoodList=" + idFoodList + ", date=" + date + ", user="
				+ user + "]";
	}

	
	
	
	

}
