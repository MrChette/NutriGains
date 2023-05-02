	package com.springapi.serviceImpl;

import java.util.List;
import java.util.stream.Collectors;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import com.springapi.entity.Category;
import com.springapi.entity.Product;
import com.springapi.model.ProductModel;
import com.springapi.repository.CategoryRepository;
import com.springapi.repository.ProductRepository;
import com.springapi.service.CategoryService;
import com.springapi.service.ProductService;


@Service("productServiceImpl")
public class ProductServiceImpl implements ProductService {
	
	@Autowired
	@Qualifier("categoryRepository")
	private CategoryRepository categoryRepository;
	
	
	@Autowired
	@Qualifier("productRepository")
	private ProductRepository productRepository;
	
	@Autowired
	@Qualifier("categoryServiceImpl")
	private CategoryService categoryService;

	
	
	@Override
	public ProductModel addProduct(ProductModel productModel) {
			productRepository.save(transform(productModel));
		return productModel;
	}
	
	@Override
	public ProductModel updateProduct(ProductModel productModel) {
			productRepository.save(transform(productModel));
			return productModel;
	}
	
	@Override
	public boolean removeProduct(long id) {
		if(productRepository.findByIdProduct(id)!=null) {
			productRepository.deleteById(id);
			return true;
		}
			return false;
			
	}
	
	@Override
	public boolean removeProductsInCategory(long id) {
		if(categoryRepository.findById(id)!=null) {
			List<ProductModel> products = listAllProductsByCategory(id);
			if(!products.isEmpty()) {
					products.stream().map(c -> removeProduct(c.getId())).collect(Collectors.toList());
				return true;
			}
			return false;
		}
		return false;
	}
	
	@Override
	public List<ProductModel> listAllProductsByCategory(long id) {
			Category category = categoryService.transform(categoryService.findCategoryByIdModel(id));
		return productRepository.findAll().stream().filter(p -> p.getCategory().getId() == category.getId()).map(c->transform(c)).collect(Collectors.toList());
	}
	
	@Override
	public List<ProductModel> listAllProducts() {
		return productRepository.findAll().stream().map(c -> transform(c)).collect(Collectors.toList());
	}

	@Override
	public Product findProductById(long id) {
		return productRepository.findByIdProduct(id);
	}

	@Override
	public ProductModel findProductByIdModel(long id) {
		return transform(productRepository.findByIdProduct(id));
	}

	@Override
	public Product transform(ProductModel productModel) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(productModel, Product.class);
	}

	@Override
	public ProductModel transform(Product product) {
		ModelMapper modelMapper = new ModelMapper();
		return modelMapper.map(product, ProductModel.class);
	}

}	
