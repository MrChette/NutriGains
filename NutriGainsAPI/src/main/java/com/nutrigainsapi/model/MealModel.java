package com.nutrigainsapi.model;

import java.util.Date;

public class MealModel {
	
	private long id;
	private Date date;
	private long idUser;
	
	public MealModel() {
		super();
	}

	public MealModel(long id, Date date, long idUser) {
		super();
		this.id = id;
		this.date = date;
		this.idUser = idUser;
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

	public long getIdUser() {
		return idUser;
	}

	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}

	@Override
	public String toString() {
		return "MealModel [id=" + id + ", date=" + date + ", idUser=" + idUser + "]";
	}

	

	
	
	
	
	

}
