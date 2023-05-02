package com.springapi.service;

import java.util.List;
import com.springapi.entity.Product;
import com.springapi.model.ProductModel;


public interface ProductService {
	
	public abstract ProductModel addProduct(ProductModel productModel);
	public abstract List<ProductModel> listAllProductsByCategory(long id);
	public abstract boolean removeProductsInCategory(long id);
	public abstract Product findProductById(long id);
	public abstract ProductModel findProductByIdModel(long id);
	public abstract ProductModel updateProduct(ProductModel productModel);
	public abstract boolean removeProduct(long id);
	public abstract Product transform(ProductModel productModel);
	public abstract ProductModel transform(Product product);
	public abstract List<ProductModel> listAllProducts();
}
