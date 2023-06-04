package com.nutrigainsapi.model;


public class RecipeModel extends NutritionalDataModel {
	
	private long id;
	private String name;
	private long idUser;
	private int bePublic;
	private int visible;
	
	public RecipeModel() {
		super();
	}
	
	

	public RecipeModel(double kcal, double protein, double fat, double carbohydrates, double sugar, double salt,
			long id, String name, long idUser, int bePublic, int visible) {
		super(kcal, protein, fat, carbohydrates, sugar, salt);
		this.id = id;
		this.name = name;
		this.idUser = idUser;
		this.bePublic = bePublic;
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

	





	public int getBePublic() {
		return bePublic;
	}



	public void setBePublic(int bePublic) {
		this.bePublic = bePublic;
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
		return "RecipeModel [id=" + id + ", name=" + name + ", idUser=" + idUser + ", bePublic=" + bePublic
				+ ", getFat()=" + getFat() + ", getKcal()=" + getKcal() + ", getProtein()=" + getProtein()
				+ ", getCarbohydrates()=" + getCarbohydrates() + ", getSugar()=" + getSugar() + ", getSalt()="
				+ getSalt() + ", toString()=" + super.toString() + ", getClass()=" + getClass() + ", hashCode()="
				+ hashCode() + "]";
	}



	



	



	

	
	
	
	
	
	

}
