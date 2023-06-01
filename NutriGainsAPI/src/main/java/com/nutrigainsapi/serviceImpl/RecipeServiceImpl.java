package com.nutrigainsapi.serviceImpl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.nutrigainsapi.entity.Recipe;
import com.nutrigainsapi.model.RecipeModel;
import com.nutrigainsapi.repository.RecipeRepository;
import com.nutrigainsapi.service.GenericService;


@Service("recipeServiceImpl")
public class RecipeServiceImpl implements GenericService<Recipe,RecipeModel,Long>{

	@Autowired
	@Qualifier("recipeRepository")
	private RecipeRepository recipeRepository;
	
	@Override
	public Recipe addEntity(RecipeModel model) {
		return recipeRepository.save(transform(model));
	}

	@Override
	public boolean removeEntity(Long id) {
		if(recipeRepository.findById(id)!=null) {
			recipeRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public Recipe updateEntity(RecipeModel model) {
		return recipeRepository.save(transform(model));
	}

	@Override
	public Recipe findEntityById(Long id) {
		return recipeRepository.findById(id).orElse(null);
	}

	@Override
	public RecipeModel findModelById(Long id) {
		return transformToModel(recipeRepository.findById(id).orElse(null));
	}

	@Override
	public Recipe transform(RecipeModel model) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(model, Recipe.class);
	}

	@Override
	public RecipeModel transformToModel(Recipe entity) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(entity, RecipeModel.class);
	}

	@Override
	public List<RecipeModel> listAll() {
		return recipeRepository.findAll().stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
		}
	

}
