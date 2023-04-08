package com.nutrigainsapi.serviceImpl;

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

import com.nutrigainsapi.repository.UserRepository;



@Service("userService")
public class UserService implements UserDetailsService {

	@Autowired
	@Qualifier("userRepository")
	private UserRepository userRepository;

	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		com.nutrigainsapi.entity.User usuario = userRepository.findByUsername(username);

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

	public com.nutrigainsapi.entity.User registrar(com.nutrigainsapi.entity.User user) {
		user.setUsername(user.getUsername());
		user.setPassword(passwordEncoder().encode(user.getPassword()));
		user.setEnabled(true);
		user.setRole("ROLE_USER");
		return userRepository.save(user);
	}

	public int activar(String username) {
		int a = 0;
		com.nutrigainsapi.entity.User u = userRepository.findByUsername(username);
		com.nutrigainsapi.entity.User user = new com.nutrigainsapi.entity.User();
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
		com.nutrigainsapi.entity.User u = userRepository.findByUsername(username);
		userRepository.delete(u);
	}

	public List<com.nutrigainsapi.entity.User> listAllUsuarios() {
		return userRepository.findAll().stream().collect(Collectors.toList());
	}

	public com.nutrigainsapi.entity.User findUsuario(String username) {
		return userRepository.findByUsername(username);
	}
	

}