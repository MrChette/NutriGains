package com.nutrigainsapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.RecipeList;

@Repository("recipeListRepository")
public interface RecipeListRepository extends JpaRepository<RecipeList,Serializable>{

		public abstract RecipeList findById(long id);
}
