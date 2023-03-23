package com.nutrigainsapi.model;

import java.util.List;

public class RecipeModel {
	
	private long id;
	private String name;
	private List<Long> idFoods;
	
	public RecipeModel() {
		super();
	}

	public RecipeModel(long id, String name, List<Long> idFoods) {
		super();
		this.id = id;
		this.name = name;
		this.idFoods = idFoods;
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

	public List<Long> getIdFoods() {
		return idFoods;
	}

	public void setIdFoods(List<Long> idFoods) {
		this.idFoods = idFoods;
	}

	@Override
	public String toString() {
		return "RecipeModel [id=" + id + ", name=" + name + ", idFoods=" + idFoods + "]";
	}
	
	
	
	
	
	
	

}
