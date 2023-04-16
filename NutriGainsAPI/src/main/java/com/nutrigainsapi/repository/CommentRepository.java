package com.nutrigainsapi.repository;

import java.io.Serializable;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.nutrigainsapi.entity.Comment;

@Repository("commentRepository")
public interface CommentRepository extends JpaRepository<Comment,Serializable>{

		public abstract Comment findById(long id);

}
