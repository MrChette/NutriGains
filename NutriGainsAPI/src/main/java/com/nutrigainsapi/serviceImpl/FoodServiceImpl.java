package com.nutrigainsapi.serviceImpl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.model.FoodModel;
import com.nutrigainsapi.repository.FoodRepository;
import com.nutrigainsapi.service.GenericService;


@Service("foodServiceImpl")
public class FoodServiceImpl implements GenericService<Food,FoodModel,Long>{
	
	@Autowired
	@Qualifier("foodRepository")
	private FoodRepository foodRepository;

	@Override
	public Food addEntity(FoodModel model) {
		return foodRepository.save(transform(model));
	}

	@Override
	public boolean removeEntity(Long id) {
		if(foodRepository.findById(id)!=null) {
			foodRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public Food updateEntity(FoodModel model) {
		return foodRepository.save(transform(model));
	}

	@Override
	public Food findEntityById(Long id) {
		return foodRepository.findById(id).orElse(null);
	}

	@Override
	public FoodModel findModelById(Long id) {
		return transformToModel(foodRepository.findById(id).orElse(null));
	}

	@Override
	public Food transform(FoodModel model) {
		ModelMapper mp = new ModelMapper();
		return mp.map(model, Food.class);
	}

	@Override
	public FoodModel transformToModel(Food entity) {
		ModelMapper mp = new ModelMapper();
		return mp.map(entity, FoodModel.class);
	}

	@Override
	public List<FoodModel> listAll() {
		return foodRepository.findAll().stream()
				.map(c->transformToModel(c)).collect(Collectors.toList());
	}


}
