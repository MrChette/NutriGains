package com.nutrigainsapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.Food;

@Repository("foodRepository")
public interface FoodRepository extends JpaRepository<Food,Serializable>{
	
	public abstract Food findById(long id);

}
