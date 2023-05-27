package com.nutrigainsapi.serviceImpl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.MealModel;
import com.nutrigainsapi.repository.MealRepository;
import com.nutrigainsapi.service.GenericService;

@Service("mealServiceImpl")
public class MealServiceImpl implements GenericService<Meal,MealModel,Long>{
	
	@Autowired
	@Qualifier("mealRepository")
	private MealRepository mealRepository;

	@Override
	public Meal addEntity(MealModel model) {
		return mealRepository.save(transform(model));
	}

	@Override
	public boolean removeEntity(Long id) {
		if(mealRepository.findById(id)!=null) {
			mealRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public Meal updateEntity(MealModel model) {
		return mealRepository.save(transform(model));
	}

	@Override
	public Meal findEntityById(Long id) {
		return mealRepository.findById(id).orElse(null);
	}

	@Override
	public MealModel findModelById(Long id) {
		return transformToModel(mealRepository.findById(id).orElse(null));
	}

	@Override
	public Meal transform(MealModel model) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(model, Meal.class);
	}
	
	
	public List<Meal> transformList	(List<MealModel> models) {
	    ModelMapper modelMapper = new ModelMapper();
	    List<Meal> meals = new ArrayList<>();

	    for (MealModel model : models) {
	        Meal meal = modelMapper.map(model, Meal.class);
	        meals.add(meal);
	    }

	    return meals;
	}

	@Override
	public MealModel transformToModel(Meal entity) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(entity, MealModel.class);
	}

	@Override
	public List<MealModel> listAll() {
		return mealRepository.findAll().stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
	}
	
	public List<MealModel> findMealByDate(Date date) {
        return mealRepository.findByDate(date).stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
    }


}
