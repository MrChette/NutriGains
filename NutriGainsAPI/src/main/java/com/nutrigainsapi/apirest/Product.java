package com.nutrigainsapi.apirest;

import com.fasterxml.jackson.annotation.JsonProperty;

public class Product {
    private String code;
    private ProductDetails product;

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public ProductDetails getProduct() {
        return product;
    }

    public void setProduct(ProductDetails product) {
        this.product = product;
    }

    public static class ProductDetails {
        private Nutriments nutriments;
        private String product_name;

        public Nutriments getNutriments() {
            return nutriments;
        }

        public void setNutriments(Nutriments nutriments) {
            this.nutriments = nutriments;
        }

        public String getProduct_name() {
            return product_name;
        }

        public void setProduct_name(String product_name) {
            this.product_name = product_name;
        }

        public static class Nutriments {
        	
        	@JsonProperty("energy-kcal_100g")
            private double energykcal;
        	@JsonProperty("proteins_100g")
            private double proteins;
        	@JsonProperty("fat_100g")
            private double fat;
        	@JsonProperty("carbohydrates_100g")
            private double carbohydrates;
        	@JsonProperty("sugars_100g")
            private double sugars;
        	@JsonProperty("salt_100g")
            private double salt;

            

			public double getEnergykcal() {
				return energykcal;
			}

			public void setEnergykcal(double energy_kcal) {
				this.energykcal = energy_kcal;
			}

			public double getProteins() {
                return proteins;
            }

            public void setProteins(double proteins) {
                this.proteins = proteins;
            }

            public double getFat() {
                return fat;
            }

            public void setFat(double fat) {
                this.fat = fat;
            }

            public double getCarbohydrates() {
                return carbohydrates;
            }

            public void setCarbohydrates(double carbohydrates) {
                this.carbohydrates = carbohydrates;
            }

            public double getSugars() {
                return sugars;
            }

            public void setSugars(double sugars) {
                this.sugars = sugars;
            }

            public double getSalt() {
                return salt;
            }

            public void setSalt(double salt) {
                this.salt = salt;
            }

            
        }
    }    
    
}
