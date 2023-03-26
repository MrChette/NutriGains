package com.nutrigainsapi.model;

public class CommentModel {
	
	private long id;
	private String comment;
	private long idRecipe;
	private long idUser;
	
	public CommentModel() {
		super();
	}

	public CommentModel(long id, String comment, long idRecipe, long idUser) {
		super();
		this.id = id;
		this.comment = comment;
		this.idRecipe = idRecipe;
		this.idUser = idUser;
	}

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getComment() {
		return comment;
	}

	public void setComment(String comment) {
		this.comment = comment;
	}

	public long getIdRecipe() {
		return idRecipe;
	}

	public void setIdRecipe(long idRecipe) {
		this.idRecipe = idRecipe;
	}

	public long getIdUser() {
		return idUser;
	}

	public void setIdUser(long idUser) {
		this.idUser = idUser;
	}

	@Override
	public String toString() {
		return "CommentModel [id=" + id + ", comment=" + comment + ", idRecipe=" + idRecipe + ", idUser=" + idUser
				+ "]";
	}
	
	
	
	

}
