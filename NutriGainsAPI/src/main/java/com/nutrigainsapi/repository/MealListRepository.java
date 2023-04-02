package com.nutrigainsapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.MealList;


@Repository("mealListRepository")
public interface MealListRepository extends JpaRepository<MealList,Serializable>{
	
	public abstract MealList findById(long id);	
	
}
