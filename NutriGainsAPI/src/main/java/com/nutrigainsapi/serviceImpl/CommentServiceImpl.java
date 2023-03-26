package com.nutrigainsapi.serviceImpl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.nutrigainsapi.entity.Comment;
import com.nutrigainsapi.model.CommentModel;
import com.nutrigainsapi.repository.CommentRepository;
import com.nutrigainsapi.service.CommentService;

@Service("commentServiceImpl")
public class CommentServiceImpl implements CommentService {
	
	@Autowired
	@Qualifier
	private CommentRepository commentRepository;

	@Override
	public Comment addComment(CommentModel commentModel) {
		return commentRepository.save(transform(commentModel));
	}
	
	@Override
	public Comment updateComment(CommentModel commentModel) {
		return commentRepository.save(transform(commentModel));
	}

	@Override
	public boolean removeComment(long id) {
		if(commentRepository.findById(id)!=null) {
			commentRepository.deleteById(id);
			return true;
		}
		return false;
	}


	@Override
	public Comment findCommentById(long id) {
		return commentRepository.findById(id);
	}

	@Override
	public CommentModel findCommentByIdModel(long id) {
		return transform(commentRepository.findById(id));
	}

	@Override
	public Comment transform(CommentModel commentModel) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(commentModel, Comment.class);
	}

	@Override
	public CommentModel transform(Comment comment) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(comment, CommentModel.class);
	}

	@Override
	public List<CommentModel> listAllComment() {
		return commentRepository.findAll().stream()
				.map(c->transform(c)).collect(Collectors.toList());
	}

}
