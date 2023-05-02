package com.springapi.model;

public class User {
	
		private long id;
		private String username;
		private String password;
		private boolean enabled;
		private String role;
		private String token;

		
		public User() {
			super();
		}
		
		public User(long id, String username, String password, boolean enabled, String role, String token) {
			super();
			this.id = id;
			this.username = username;
			this.password = password;
			this.enabled = enabled;
			this.role = role;
			this.token = token;
		}

		public long getId() {
			return id;
		}
		public void setId(long id) {
			this.id = id;
		}
		public String getUsername() {
			return username;
		}
		public void setUsername(String username) {
			this.username = username;
		}
		public String getPassword() {
			return password;
		}
		public void setPassword(String password) {
			this.password = password;
		}
		public boolean isEnabled() {
			return enabled;
		}
		public void setEnabled(boolean enabled) {
			this.enabled = enabled;
		}
		public String getRole() {
			return role;
		}
		public void setRole(String role) {
			this.role = role;
		}
		public String getToken() {
			return token;
		}
		public void setToken(String token) {
			this.token = token;
		}
		@Override
		public String toString() {
			return "User [id=" + id + ", username=" + username + ", password=" + password + ", enabled=" + enabled
					+ ", role=" + role + ", token=" + token + "]";
		}

}
