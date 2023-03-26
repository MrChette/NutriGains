package com.nutrigainsapi.service;

import java.util.List;

import com.nutrigainsapi.entity.Comment;
import com.nutrigainsapi.model.CommentModel;

public interface CommentService {
	
	public abstract Comment addComment(CommentModel commentModel);
	public abstract boolean removeComment(long id);
	public abstract Comment updateComment(CommentModel commentModel);
	public abstract Comment findCommentById(long id);
	public abstract CommentModel findCommentByIdModel(long id);
	public abstract Comment transform(CommentModel commentModel);
	public abstract CommentModel transform(Comment comment);
	public abstract List<CommentModel> listAllComment();
	
	
	

}

