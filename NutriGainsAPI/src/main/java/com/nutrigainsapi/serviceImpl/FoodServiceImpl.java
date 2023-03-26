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
import com.nutrigainsapi.service.FoodService;


@Service("foodServiceImpl")
public class FoodServiceImpl implements FoodService{
	
	@Autowired
	@Qualifier("foodRepository")
	private FoodRepository foodRepository;

	@Override
	public Food addFood(FoodModel foodModel) {
		return foodRepository.save(transform(foodModel));
	}
	
	@Override
	public Food updateFood(FoodModel foodModel) {
		return foodRepository.save(transform(foodModel));
	}
	
	@Override
	public boolean removeFood(long id) {
		if(foodRepository.findById(id)!=null) {
			foodRepository.deleteById(id);
			return true;
		}
		return false;
	}

	@Override
	public Food findFoodById(long id) {
		return foodRepository.findById(id);
	}

	@Override
	public FoodModel finfCategoryByIdModel(long id) {
		return transform(foodRepository.findById(id));
	}

	@Override
	public Food transform(FoodModel foodModel) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(foodModel, Food.class);
	}

	@Override
	public FoodModel transform(Food food) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(food, FoodModel.class);
	}

	@Override
	public List<FoodModel> listAllFood() {
		return foodRepository.findAll().stream()
				.map(c->transform(c)).collect(Collectors.toList());
	}

}
