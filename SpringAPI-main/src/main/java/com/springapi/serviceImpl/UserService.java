package com.springapi.serviceImpl;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.User.UserBuilder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.springapi.repository.UserRepository;

@Service("userService")
public class UserService implements UserDetailsService {

	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		com.springapi.entity.User usuario = userRepository.findByUsername(username);

		UserBuilder builder = null;

		if (usuario != null) {
			builder = User.withUsername(username);
			builder.disabled(false);
			builder.password(usuario.getPassword());
			builder.authorities(new SimpleGrantedAuthority(usuario.getRole()));

		} else
			throw new UsernameNotFoundException("Usuario no encontrado");
		return builder.build();
	}

	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	public com.springapi.entity.User registrar(com.springapi.entity.User user) {
		user.setUsername(user.getUsername());
		user.setPassword(passwordEncoder().encode(user.getPassword()));
		user.setEnabled(true);
		user.setRole("ROLE_USER");
		user.setListFavs(new ArrayList());
		return userRepository.save(user);
	}

	public int activar(String username) {
		int a = 0;
		com.springapi.entity.User u = userRepository.findByUsername(username);
		com.springapi.entity.User user = new com.springapi.entity.User();
		user.setPassword(passwordEncoder().encode(u.getPassword()));
		user.setUsername(u.getUsername());
		user.setId(u.getId());

		if (u.isEnabled() == false) {
			user.setEnabled(true);
			a = 1;
		} else {
			user.setEnabled(false);
			a = 0;
		}
		user.setRole(u.getRole());

		userRepository.save(user);
		return a;
	}

	public void deleteUser(String username) throws Exception {
		com.springapi.entity.User u = userRepository.findByUsername(username);
		userRepository.delete(u);
	}

	public List<com.springapi.entity.User> listAllUsuarios() {
		return userRepository.findAll().stream().collect(Collectors.toList());
	}

	public com.springapi.entity.User findUsuario(String username) {
		return userRepository.findByUsername(username);
	}
	

	
	public com.springapi.entity.User addFav(int id,String username) {
		com.springapi.entity.User u= findUsuario(username);
		ArrayList<Integer> list = u.getListFavs();
		list.add(id);
		u.setListFavs(list);
		System.out.println(list);
		return userRepository.save(u);

	}
	
	public com.springapi.entity.User delFav(int id,String username) {
		com.springapi.entity.User u= findUsuario(username);
		ArrayList<Integer> list = u.getListFavs();
		list.remove(Integer.valueOf(id));
		u.setListFavs(list);
		return userRepository.save(u);
	}
	
	public List<Integer> getFavs(String username) {
		com.springapi.entity.User u= findUsuario(username);
		ArrayList<Integer> list = u.getListFavs();
		return list;
	}
}