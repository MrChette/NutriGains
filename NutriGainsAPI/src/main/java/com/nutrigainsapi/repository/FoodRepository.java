package com.nutrigainsapi.repository;

import java.io.Serializable;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.Food;
import com.nutrigainsapi.model.FoodModel;

@Repository("foodRepository")
public interface FoodRepository extends JpaRepository<Food,Serializable>{
	
	public abstract Food findById(long id);
	public abstract List<Food> findByUserId(Long userId);
	public abstract Food findByBarcode(long barcode);
	public abstract List<FoodModel> findAllByIdIn(List<Long> ids);

}
