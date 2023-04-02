package com.nutrigainsapi.model;

import java.util.List;

public class RecipeModel {
	
	private long id;
	private String name;
	private long idUser;
	
	public RecipeModel() {
		super();
	}

	public RecipeModel(long id, String name, long idUser) {
		super();
		this.id = id;
		this.name = name;
		this.idUser = idUser;
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

	public long getIdUser() {
		return idUser;
	}

	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}

	@Override
	public String toString() {
		return "RecipeModel [id=" + id + ", name=" + name + ", idUser=" + idUser + "]";
	}

	
	
	
	
	
	

}
