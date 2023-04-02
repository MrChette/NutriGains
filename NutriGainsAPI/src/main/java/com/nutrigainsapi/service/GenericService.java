package com.nutrigainsapi.service;

import java.util.List;

public interface GenericService<T, M, ID>  {
	
	T addEntity(M model);
    boolean removeEntity(ID id);
    T updateEntity(M model);
    T findEntityById(ID id);
    M findModelById(ID id);
    T transform(M model);
    M transformToModel(T entity);
    List<M> listAll();

}
