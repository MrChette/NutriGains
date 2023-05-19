//package com.nutrigainsapi.serviceImpl;
//
//import java.util.List;
//import java.util.stream.Collectors;
//
//import org.modelmapper.ModelMapper;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Qualifier;
//import org.springframework.stereotype.Service;
//
//import com.nutrigainsapi.entity.MealList;
//import com.nutrigainsapi.model.MealListModel;
//import com.nutrigainsapi.repository.MealListRepository;
//import com.nutrigainsapi.service.GenericService;
//
//
//@Service("mealListServiceImpl")
//public class MealListServiceImpl implements GenericService<MealList,MealListModel,Long> {
//	
//	@Autowired
//	@Qualifier("mealListRepository")
//	private MealListRepository mealListRepository;
//
//	@Override
//	public MealList addEntity(MealListModel model) {
//		return mealListRepository.save(transform(model));
//	}
//
//	@Override
//	public boolean removeEntity(Long id) {
//		if(mealListRepository.findById(id)!=null) {
//			mealListRepository.deleteById(id);
//			return true;
//		}
//		return false;
//	}
//
//	@Override
//	public MealList updateEntity(MealListModel model) {
//		return mealListRepository.save(transform(model));
//	}
//
//	@Override
//	public MealList findEntityById(Long id) {
//		return mealListRepository.findById(id).orElse(null);
//	}
//
//	@Override
//	public MealListModel findModelById(Long id) {
//		return transformToModel(mealListRepository.findById(id).orElse(null));
//	}
//
//	@Override
//	public MealList transform(MealListModel model) {
//		ModelMapper modelMapper = new ModelMapper();
//		return modelMapper.map(model, MealList.class);
//		
//	}
//
//	@Override
//	public MealListModel transformToModel(MealList entity) {
//		ModelMapper modelMapper = new ModelMapper();
//		return modelMapper.map(entity, MealListModel.class);
//	}
//
//	@Override
//	public List<MealListModel> listAll() {
//		return mealListRepository.findAll().stream()
//				.map(c->transformToModel(c)).collect(Collectors.toList());
//	}
//
//
//}
