package com.springapi.serviceImpl;





import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.springapi.entity.Category;
import com.springapi.model.CategoryModel;
import com.springapi.repository.CategoryRepository;
import com.springapi.repository.ProductRepository;
import com.springapi.service.CategoryService;


@Service("categoryServiceImpl")
public class CategoryServiceImpl implements CategoryService{
	
	
	@Autowired
	@Qualifier("categoryRepository")
	private CategoryRepository categoryRepository;
	
	@Autowired
	@Qualifier("productRepository")
	private ProductRepository productRepository;
	

	

	@Override
	public Category addCategory(CategoryModel categoryModel) {
		return categoryRepository.save(transform(categoryModel));
	}
	
	@Override
	public Category updateCategory(CategoryModel categoryModel) {
		return categoryRepository.save(transform(categoryModel));
	}
	
	@Override
	public boolean removeCategory(long id) {
		if(categoryRepository.findById(id)!=null) {
			categoryRepository.deleteById(id);
			return true;
		}
			return false;
	}
	
	

	@Override
	public Category findCategoryById(long id) {
		return categoryRepository.findById(id);
	}
	@Override
	public CategoryModel findCategoryByIdModel(long id) {
		return transform(categoryRepository.findById(id));
	}
	
	@Override
	public Category transform(CategoryModel categoryModel) {
		ModelMapper modelMapper=new ModelMapper();
		return modelMapper.map(categoryModel, Category.class);
	}

	@Override
	public CategoryModel transform(Category category) {
		ModelMapper modelMapper=new ModelMapper();
		return modelMapper.map(category, CategoryModel.class);
	}

	
	@Override
	public List<CategoryModel> listAllCategories() {
		return categoryRepository.findAll().stream().
				map(c->transform(c)).collect(Collectors.toList());
	}






}
