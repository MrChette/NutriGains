package com.nutrigainsapi.repository;

import java.io.Serializable;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.User;


@Repository("userRepository")
public interface UserRepository extends JpaRepository<User,Serializable>{
	public abstract User findByUsername(String username);
	public abstract User findById(Long id);

}
