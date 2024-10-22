package com.nutrigainsapi.model;

public class FoodModel extends NutritionalDataModel{
	
	private long id;
	private Long barcode;
	private String name;
	private long idUser;
	private int visible;
	
	
	public FoodModel() {
		super();
	}

	public FoodModel(double kcal, double protein, double fat, double carbohydrates, double sugar, double salt, long id,
			Long barcode, String name, long idUser, int visible) {
		super(kcal, protein, fat, carbohydrates, sugar, salt);
		this.id = id;
		this.barcode = barcode;
		this.name = name;
		this.idUser = idUser;
		this.visible = visible;
	}

	public int getVisible() {
		return visible;
	}


	public void setVisible(int visible) {
		this.visible = visible;
	}


	public long getId() {
		return id;
	}


	public void setId(long id) {
		this.id = id;
	}


	public Long getBarcode() {
		return barcode;
	}


	public void setBarcode(Long barcode) {
		this.barcode = barcode;
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
		return "FoodModel [id=" + id + ", barcode=" + barcode + ", name=" + name + ", idUser=" + idUser + "]";
	}

	
	


	
	
	
	



	
	
	
	
}
