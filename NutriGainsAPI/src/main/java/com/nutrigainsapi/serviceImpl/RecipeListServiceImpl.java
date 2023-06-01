package com.nutrigainsapi.serviceImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.nutrigainsapi.entity.RecipeList;
import com.nutrigainsapi.model.RecipeListModel;
import com.nutrigainsapi.repository.RecipeListRepository;
import com.nutrigainsapi.service.GenericService;

@Service("recipeListServiceImpl")
public class RecipeListServiceImpl implements GenericService<RecipeList,RecipeListModel,Long> {

	
	@Autowired
	@Qualifier("recipeListRepository")
	private RecipeListRepository recipeListRepository;
	
	
	@Override
	public RecipeList addEntity(RecipeListModel model) {
		return recipeListRepository.save(transform(model));
	}
	
	public List<RecipeListModel> addEntities(List<RecipeListModel> models) {
		for(RecipeListModel x : models) {
			recipeListRepository.save(transform(x));
		}
	    return models;
	}
	
	@Override
	public boolean removeEntity(Long id) {
		if(recipeListRepository.findById(id)!=null) {
			recipeListRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public RecipeList updateEntity(RecipeListModel model) {
		return recipeListRepository.save(transform(model));
	}

	@Override
	public RecipeList findEntityById(Long id) {
		return recipeListRepository.findById(id).orElse(null);
	}

	@Override
	public RecipeListModel findModelById(Long id) {
		return transformToModel(recipeListRepository.findById(id).orElse(null));
	}

	@Override
	public RecipeList transform(RecipeListModel model) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(model, RecipeList.class);
	}

	@Override
	public RecipeListModel transformToModel(RecipeList entity) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(entity, RecipeListModel.class);
	}

	@Override
	public List<RecipeListModel> listAll() {
		return recipeListRepository.findAll().stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
	}
	
	public List<RecipeListModel> getListRecipesByRecipeId(long idRecipe) {
        return recipeListRepository.findByidRecipe(idRecipe).stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
    }

}
