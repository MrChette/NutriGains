package com.springapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


import com.springapi.entity.Category;


@Repository("categoryRepository")
public interface CategoryRepository extends JpaRepository<Category,Serializable>{
	
	public abstract Category findById(long id);

	
}
