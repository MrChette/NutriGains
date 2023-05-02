package com.springapi.model;

public class CategoryModel {
	
	private long id;
	private String name;
	private String description;
	
	public CategoryModel() {
		super();
	}

	public CategoryModel(long id, String name, String description) {
		super();
		this.id = id;
		this.name = name;
		this.description = description;
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Override
	public String toString() {
		return "CategoryModel [id=" + id + ", name=" + name + ", description=" + description + "]";
	}
	
	
	
	

}
