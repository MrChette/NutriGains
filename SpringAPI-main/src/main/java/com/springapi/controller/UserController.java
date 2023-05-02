package com.springapi.controller;

import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.springapi.serviceImpl.UserService;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;

@RestController
public class UserController {
	

	@Autowired
	@Qualifier("userService")
	private UserService userService;
	
	
	
	@Autowired
	private AuthenticationManager authenticationManager;
		
	@PostMapping("/login")
	public com.springapi.entity.User login(@RequestParam("username") String username,
			@RequestParam("password") String password) {
		Authentication authentication = authenticationManager
				.authenticate(new UsernamePasswordAuthenticationToken(username, password));
		SecurityContextHolder.getContext().setAuthentication(authentication);
		com.springapi.entity.User usuario = userService.findUsuario(username);
		String token = getJWTToken(username);
		usuario.setUsername(username);
		usuario.setPassword(password);
		usuario.setToken(token);
		return usuario;
	}


	@PostMapping("/register")
	public ResponseEntity<?> saveUser(@RequestBody com.springapi.entity.User user){
		boolean exist = userService.findUsuario(user.getUsername())!=null;
		if(exist) {
			return ResponseEntity.internalServerError().body(null);
		}else {
			return ResponseEntity.status(HttpStatus.CREATED).body(userService.registrar(user));
		}
	}

	private String getJWTToken(String username) {
	String secretKey = "mySecretKey";
	List<GrantedAuthority> grantedAuthorities = AuthorityUtils.commaSeparatedStringToAuthorityList(userService.findUsuario(username).getRole());
	System.out.println(userService.findUsuario(username).getRole());
	String token = Jwts
			.builder()
			.setId("softtekJWT")
			.setSubject(username)
			.claim("authorities", grantedAuthorities.stream()
										.map(GrantedAuthority::getAuthority)
										.collect(Collectors.toList()))
			.setIssuedAt(new Date(System.currentTimeMillis()))
			.setExpiration(new Date(System.currentTimeMillis()+600000))
			.signWith(SignatureAlgorithm.HS512,
					secretKey.getBytes()).compact();
	return "Bearer " + token;
	}
}
