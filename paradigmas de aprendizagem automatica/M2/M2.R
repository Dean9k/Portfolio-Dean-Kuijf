dados <- read.csv("Airbnb_NYC_2019.csv")
View(dados)

# price

lower_bound <- quantile(dados$price, 0.025)
upper_bound <- quantile(dados$price, 0.975)
outliers <- which(dados$price < lower_bound | dados$price > upper_bound)
dados$price[outliers] 
length(dados$price[outliers])
# 2008    # inclui os 0
inliers <- which(dados$price >= lower_bound & dados$price <= upper_bound)
dados$price[inliers]
c(min(dados$price[inliers]),max(dados$price[inliers]))
# 35 500

z_dados <- scale(dados$price)
outliers <- which(z_dados > 3.29 | z_dados < (-3.29))
dados$price[outliers]
length(dados$price[outliers])
# 349     # exclui os 0
inliers <- which(z_dados <= 3.29 & z_dados >= (-3.29))
dados$price[inliers]
c(min(dados$price[inliers]),max(dados$price[inliers]))
# 0 935

sum(dados$price == 0) # 11
sum(dados$price >= 0 & dados$price < 10) # 11
sum(dados$price >= 0 & dados$price < 20) # 54

dados <- dados[dados$price != 0,] # ficam 48884 linhas


# minimum_nights

lower_bound <- quantile(dados$minimum_nights, 0.025)
upper_bound <- quantile(dados$minimum_nights, 0.975)
outliers <- which(dados$minimum_nights < lower_bound | dados$minimum_nights > upper_bound)
dados$minimum_nights[outliers]
length(dados$minimum_nights[outliers])
# 747
inliers <- which(dados$minimum_nights >= lower_bound & dados$minimum_nights <= upper_bound)
dados$minimum_nights[inliers]
c(min(dados$minimum_nights[inliers]),max(dados$minimum_nights[inliers]))
# 1 30

z_dados <- scale(dados$minimum_nights)
outliers <- which(z_dados > 3.29 | z_dados < (-3.29))
dados$minimum_nights[outliers]
length(dados$minimum_nights[outliers])
# 318
inliers <- which(z_dados <= 3.29 & z_dados >= (-3.29))
dados$minimum_nights[inliers]
c(min(dados$minimum_nights[inliers]),max(dados$minimum_nights[inliers]))
# 1 74

sum(dados$minimum_nights == 0) # 0


# remover linhas em que price > 3000 ou minimum_nights > 200
dados <- dados[dados$price <= 3000,] # ficam 48852 linhas
dados <- dados[dados$minimum_nights <= 200,] # ficam 48838 linhas


write.csv(dados, "AB_NYC_2019_.csv", row.names = FALSE)