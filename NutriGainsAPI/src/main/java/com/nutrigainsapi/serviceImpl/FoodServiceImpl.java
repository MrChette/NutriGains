package com.nutrigainsapi.serviceImpl;

import java.util.List;

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
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean removeEntity(Long id) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public Food updateEntity(FoodModel model) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Food findEntityById(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public FoodModel findModelById(Long id) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Food transform(FoodModel model) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public FoodModel transformToModel(Food entity) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<FoodModel> listAll() {
		// TODO Auto-generated method stub
		return null;
	}


}
