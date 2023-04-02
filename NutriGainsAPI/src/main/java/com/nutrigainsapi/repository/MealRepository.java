package com.nutrigainsapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;

import com.nutrigainsapi.entity.Meal;

public interface MealRepository extends JpaRepository<Meal, Serializable>{

	public abstract Meal findById(long id);
	
}
