package com.nutrigainsapi.repository;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.MealModel;


public interface MealRepository extends JpaRepository<Meal, Serializable>{

	public abstract Meal findById(long id);
	public abstract List<Meal> findAllByUserId(Long id);
	public abstract List<Meal> findByDate(Date date);
	public abstract Meal saveAndFlush(MealModel mealModel);
	public abstract List<MealModel> findAllByDateAndUserId(Date date, Long userId);
	
	
}
