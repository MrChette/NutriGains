package com.nutrigainsapi.service;

import java.util.List;

import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.model.FoodModel;

public interface FoodService {
	
	public abstract Food addFood(FoodModel foodModel);
	public abstract boolean removeFood(long id);
	public abstract Food updateFood(FoodModel foodModel);
	public abstract Food findFoodById(long id);
	public abstract FoodModel finfCategoryByIdModel(long id);
	public abstract Food transform(FoodModel foodModel);
	public abstract FoodModel transform(Food food);
	public abstract List<FoodModel> listAllFood();

}
