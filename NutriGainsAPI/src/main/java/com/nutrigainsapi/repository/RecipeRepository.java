package com.nutrigainsapi.repository;

import java.io.Serializable;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.Recipe;

@Repository("recipeRepository")
public interface RecipeRepository extends JpaRepository<Recipe,Serializable>{

		public abstract Recipe findById(long id);
		public abstract List<Recipe> findByUserId(Long userId);

		
}
