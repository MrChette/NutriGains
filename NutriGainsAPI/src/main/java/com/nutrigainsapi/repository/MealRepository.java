package com.nutrigainsapi.repository;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.nutrigainsapi.entity.Meal;
import com.nutrigainsapi.model.MealModel;


public interface MealRepository extends JpaRepository<Meal, Serializable>{

	public abstract Meal findById(long id);
	public abstract List<Meal> findAllByUserId(Long id);
	public abstract List<Meal> findByDate(Date date);
	public abstract Meal saveAndFlush(MealModel mealModel);
	
	@Query("SELECT m FROM Meal m WHERE m.date = :date AND m.user.id= :user_id")
	public abstract List<Meal> findByDateAndUserId(@Param("date") Date date, @Param("user_id") Long userId);
	
	
}
