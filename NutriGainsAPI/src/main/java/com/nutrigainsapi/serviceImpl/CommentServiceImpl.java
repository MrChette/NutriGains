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
import com.nutrigainsapi.service.GenericService;

@Service("commentServiceImpl")
public class CommentServiceImpl implements GenericService<Comment,CommentModel,Long> {
	
	@Autowired
	@Qualifier("commentRepository")
	private CommentRepository commentRepository;

	@Override
	public Comment addEntity(CommentModel model) {
		return commentRepository.save(transform(model));
	}

	@Override
	public boolean removeEntity(Long id) {
		if(commentRepository.findById(id)!=null) {
			commentRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public Comment updateEntity(CommentModel model) {
		return commentRepository.save(transform(model));
	}

	@Override
	public Comment findEntityById(Long id) {
		return commentRepository.findById(id).orElse(null);
	}

	@Override
	public CommentModel findModelById(Long id) {
		return transformToModel(commentRepository.findById(id).orElse(null));
	}

	@Override
	public Comment transform(CommentModel model) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(model, Comment.class);
	}

	@Override
	public CommentModel transformToModel(Comment entity) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(entity, CommentModel.class);
	}

	@Override
	public List<CommentModel> listAll() {
		return commentRepository.findAll().stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
	}


	

}
