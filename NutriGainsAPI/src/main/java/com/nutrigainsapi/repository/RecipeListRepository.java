package com.nutrigainsapi.repository;

import java.io.Serializable;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.RecipeList;
import com.nutrigainsapi.model.RecipeListModel;

@Repository("recipeListRepository")
public interface RecipeListRepository extends JpaRepository<RecipeList,Serializable>{

		public abstract RecipeList findById(long id);	
		
		@Query("SELECT r FROM RecipeList r WHERE r.recipe.id = :idRecipe")
	    List<RecipeList> findByidRecipe(@Param("idRecipe") long idRecipe);
		
}
