##############################Base Model: Simple Driver Choice model with Time of Impact as an interaction term#######################################################

library(apollo)
library(foreign)
apollo_initialise()

database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
database

apollo_control=list(modelName  ="Simple base Model Dubin and Mcfadden",
                    modelDescr ="Simple Driver Choice model with constants and time of impact",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output"
                    #,panelData  = FALSE
)

apollo_beta=c(asc_acc     = 0,
              asc_brk     = 0,
              nodv_acc    = 0,
              nodv_brk    = 0,
              dist_acc    = 0,
              dist_brk    = 0,
              time_to_impact_acc  = 0,
              time_to_impact_brk  = 0
)

#all coefficients are estimated, none is fixed
apollo_fixed = c()

#check if you have defined everything necessary 
apollo_inputs = apollo_validateInputs()

apollo_probabilities=function(apollo_beta, apollo_inputs, functionality="estimate"){
  apollo_attach(apollo_beta, apollo_inputs)  
  on.exit(apollo_detach(apollo_beta, apollo_inputs))
  
  P = list() ### Create list of probabilities P
  V = list() ### List of utilities
  
  time_to_impact = (dist_ahead/gps_speed) * veh_flag
  d_ahead = dist_ahead * veh_flag
  
  V[["acc"]]  = asc_acc + time_to_impact_acc * time_of_impact + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles
  V[["brk"]]  = asc_brk + time_to_impact_brk * time_of_impact + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles
  V[["nor"]]  = 0
  
  mnl_settings = list(        
    alternatives = c(nor=0, acc=1, brk=2),
    avail        = list(nor=norm_avail, acc=accr_avail, brk=brek_avail), 
    choiceVar    = target,          
    V            = V)
  
  P[["model"]] = apollo_mnl(mnl_settings, functionality)  
  P = apollo_panelProd(P, apollo_inputs, functionality)
  P = apollo_prepareProb(P, apollo_inputs, functionality)  
  return(P)
}

Basemodeldf = apollo_estimate(apollo_beta,
                              apollo_fixed,
                              apollo_probabilities,
                              apollo_inputs)

apollo_modelOutput(Basemodeldf)
apollo_saveOutput(Basemodeldf)

hist(Basemodeldf$avgCP)

forecastbase <- apollo_prediction(Basemodeldf, apollo_probabilities, apollo_inputs)
hist(forecast1$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecastbase

estimate_selection_correction <- function(Pk) {
  
  # Inverse of the cumulative distribution function (CDF)
  #https://www.stat.umn.edu/geyer/old/5101/rlook.html#:~:text=qnorm%20is%20the%20R%20function,quantile%20of%20the%20normal%20distribution.
  
  inv_cdf <- qnorm(Pk)
  
  # Calculate the density function for the inverse CDF values
  density <- dnorm(inv_cdf)
  
  # Calculate the term
  selection_correction <- density / Pk
  
  # Return as a list
  result <- list("inv_cdf" = inv_cdf, "density" = density, "selection_correction" = selection_correction)
  
  return(result)
  
}

result_nor <- estimate_selection_correction(data$nor)
result_acc <- estimate_selection_correction(data$acc)
result_brk <- estimate_selection_correction(data$brk)


################# Calculating the Φ−1(Pk) term values for our 3 alternatives

data <- data %>%
  mutate(inv_cdf_nor = result_nor$inv_cdf)

data <- data %>%
  mutate(inv_cdf_acc = result_acc$inv_cdf)

data <- data %>%
  mutate(inv_cdf_brk = result_brk$inv_cdf)

################# Calculating the φ(Φ−1(Pk)) term values for our 3 alternatives

data <- data %>%
  mutate(density_nor = result_nor$density)

data <- data %>%
  mutate(density_acc = result_acc$density)

data <- data %>%
  mutate(density_brk = result_brk$density)

################# Calculating the selection correction regressor φ(Φ−1(Pk))/Pk term values for our 3 alternatives

data <- data %>%
  mutate(selection_correction_nor = result_nor$selection_correction)

data <- data %>%
  mutate(selection_correction_acc = result_acc$selection_correction)

data <- data %>%
  mutate(selection_correction_brk = result_brk$selection_correction)


# Print the updated table
print(data)

################### Step 2.1 / Putting all data in one data.frame

# Combine database and data
# Add all specified columns from data to database
database <- cbind(database, data[, c("nor", "acc", "brk", "chosen", "inv_cdf_nor", "inv_cdf_acc", "inv_cdf_brk", "density_nor", "density_acc", "density_brk", "selection_correction_nor", "selection_correction_acc", "selection_correction_brk")])

################### Step 3 / Using the ols function to create a linear model

# Create the linear model using lm()

database_cleaned <- database[-c(5229,5237, 5236, 5748, 5747, 1648, 1647, 5253, 1651, 5032, 5238, 3274, 5584), ]

d_ahead = database_cleaned$dist_ahead * database_cleaned$veh_flag

baselmmodel <- lm(gps_speed ~  d_ahead + num_of_det_vehicles + selection_correction_acc + selection_correction_brk, data = database_cleaned)

beta <- coef(baselmmodel)["num_of_det_vehicles"]

summary(baselmmodel)

################# Step 4 / check the performance of the baselmmodel

#install.packages("performance")
#install.packages("qqplotr")
library(performance)
library(qqplotr)

check_result <- check_model(baselmmodel)
print(check_result)

# To visualize the diagnostic plots
plot(check_result)

##############################Model 1: Vehicle Behavior Mode Choice Model considering different driver behaviors#######################################################

library(apollo)
library(foreign)
apollo_initialise()

database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
database

apollo_control=list(modelName  ="Model_1",
                    modelDescr ="Vehicle Behavior Mode Choice Model considering different driver behaviors like drowsy, aggresive",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output"
                    #,panelData  = FALSE
)

apollo_beta=c(asc_acc         = 0,
              asc_brk         = 0,
              nodv_acc        = 0,
              nodv_brk        = 0,
              dist_acc        = 0,
              dist_brk        = 0,
              time_to_impact_acc = 0,
              time_to_impact_brk = 0,
              is_drowsy_acc = 0,
              is_drowsy_brk = 0,
              is_aggressive_acc = 0,
              is_aggressive_brk = 0
)

#all coefficients are estimated, none is fixed
apollo_fixed = c()

#check if you have defined everything necessary 
apollo_inputs = apollo_validateInputs()

apollo_probabilities=function(apollo_beta, apollo_inputs, functionality="estimate"){
  apollo_attach(apollo_beta, apollo_inputs)  
  on.exit(apollo_detach(apollo_beta, apollo_inputs))
  
  P = list() ### Create list of probabilities P
  V = list() ### List of utilities
  
  time_to_impact = (dist_ahead/gps_speed) * veh_flag
  
  d_ahead = dist_ahead * veh_flag
  
  V[["acc"]]  = asc_acc + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles + time_to_impact_acc * time_to_impact + is_drowsy_acc * is_drowsy + is_aggressive_acc * is_aggressive
  V[["brk"]]  = asc_brk + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles + time_to_impact_brk * time_to_impact + is_drowsy_brk * is_drowsy + is_aggressive_brk * is_aggressive
  V[["nor"]]  = 0
  
  mnl_settings = list(        
    alternatives = c(nor=0, acc=1, brk=2),
    avail        = list(nor=norm_avail, acc=accr_avail, brk=brek_avail), 
    choiceVar    = target,          
    V            = V)
  
  P[["model"]] = apollo_mnl(mnl_settings, functionality)  
  P = apollo_panelProd(P, apollo_inputs, functionality)
  P = apollo_prepareProb(P, apollo_inputs, functionality)  
  return(P)
}


Model1 = apollo_estimate(apollo_beta,
                         apollo_fixed,
                         apollo_probabilities,
                         apollo_inputs)

apollo_modelOutput(Model1)
apollo_saveOutput(Model1)

Model1$LL0
Model1$LLout

hist(Model1$avgCP)

forecast1 <- apollo_prediction(Model1, apollo_probabilities, apollo_inputs)
hist(forecast1$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecast1

estimate_selection_correction <- function(Pk) {
  
  # Inverse of the cumulative distribution function (CDF)
  #https://www.stat.umn.edu/geyer/old/5101/rlook.html#:~:text=qnorm%20is%20the%20R%20function,quantile%20of%20the%20normal%20distribution.
  
  inv_cdf <- qnorm(Pk)
  
  # Calculate the density function for the inverse CDF values
  density <- dnorm(inv_cdf)
  
  # Calculate the term
  selection_correction <- density / Pk
  
  # Return as a list
  result <- list("inv_cdf" = inv_cdf, "density" = density, "selection_correction" = selection_correction)
  
  return(result)
  
}

result_nor <- estimate_selection_correction(data$nor)
result_acc <- estimate_selection_correction(data$acc)
result_brk <- estimate_selection_correction(data$brk)


################# Calculating the Φ−1(Pk) term values for our 3 alternatives

data <- data %>%
  mutate(inv_cdf_nor = result_nor$inv_cdf)

data <- data %>%
  mutate(inv_cdf_acc = result_acc$inv_cdf)

data <- data %>%
  mutate(inv_cdf_brk = result_brk$inv_cdf)

################# Calculating the φ(Φ−1(Pk)) term values for our 3 alternatives

data <- data %>%
  mutate(density_nor = result_nor$density)

data <- data %>%
  mutate(density_acc = result_acc$density)

data <- data %>%
  mutate(density_brk = result_brk$density)

################# Calculating the selection correction regressor φ(Φ−1(Pk))/Pk term values for our 3 alternatives

data <- data %>%
  mutate(selection_correction_nor = result_nor$selection_correction)

data <- data %>%
  mutate(selection_correction_acc = result_acc$selection_correction)

data <- data %>%
  mutate(selection_correction_brk = result_brk$selection_correction)


# Print the updated table
print(data)

################### Step 2.1 / Putting all data in one data.frame

# Combine database and data
# Add all specified columns from data to database
database <- cbind(database, data[, c("nor", "acc", "brk", "chosen", "inv_cdf_nor", "inv_cdf_acc", "inv_cdf_brk", "density_nor", "density_acc", "density_brk", "selection_correction_nor", "selection_correction_acc", "selection_correction_brk")])

################### Step 3 / Using the ols function to create a linear model

# Create the linear model using lm()

database_cleaned <- database[-c(5229,5237, 5236, 5748, 5747, 1648, 1647, 5253, 1651, 5032, 5238, 3274, 5584), ]

Model1lm <- lm(gps_speed ~ num_of_det_vehicles + is_drowsy  + is_aggressive + selection_correction_acc + selection_correction_brk, data = database_cleaned)

beta <- coef(Model1lm)["num_of_det_vehicles"]

summary(Model1lm)

################# Step 4 / check the performance of the baselmmodel

#install.packages("performance")
#install.packages("qqplotr")
library(performance)
library(qqplotr)

check_result <- check_model(Model1lm)
print(check_result)

# To visualize the diagnostic plots
plot(check_result)

##############################Model 2: Non-linear transformation (SQRT) of Distance ahead###############################################

library(apollo)
library(foreign)
apollo_initialise()

database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
database

apollo_control=list(modelName  ="Model_2",
                    modelDescr ="Non-linear transformation (SQRT) of Distance ahead and introducing lag variables",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output"
                    #,panelData  = FALSE
)

apollo_beta=c(asc_acc            = 0,
              asc_brk            = 0,
              nodv_acc           = 0,
              nodv_brk           = 0,
              dist_acc           = 0,
              dist_brk           = 0,
              time_to_impact_acc = 0,
              time_to_impact_brk = 0,
              is_drowsy_acc      = 0,
              is_drowsy_brk      = 0,
              is_aggressive_acc  = 0,
              is_aggressive_brk  = 0,
              sqrt_dist_acc      = 0,
              sqrt_dist_brk      = 0
)

#all coefficients are estimated, none is fixed
apollo_fixed = c()

#check if you have defined everything necessary 
apollo_inputs = apollo_validateInputs()

apollo_probabilities=function(apollo_beta, apollo_inputs, functionality="estimate"){
  apollo_attach(apollo_beta, apollo_inputs)  
  on.exit(apollo_detach(apollo_beta, apollo_inputs))
  
  P = list() ### Create list of probabilities P
  V = list() ### List of utilities
  
  time_to_impact = (dist_ahead/gps_speed) * veh_flag
  
  d_ahead = dist_ahead * veh_flag
  
  sqrt_dist_ahead = sqrt(dist_ahead * veh_flag)
  
  #log_dist_ahead <- log(dist_ahead * veh_flag)
  #log_dist_ahead[is.na(log_dist_ahead)] <- 0
  
  V[["acc"]]  = asc_acc + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles + time_to_impact_acc * time_to_impact + is_drowsy_acc * is_drowsy + is_aggressive_acc * is_aggressive + sqrt_dist_acc * sqrt_dist_ahead
  V[["brk"]]  = asc_brk + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles + time_to_impact_brk * time_to_impact + is_drowsy_brk * is_drowsy + is_aggressive_brk * is_aggressive + sqrt_dist_brk * sqrt_dist_ahead
  V[["nor"]]  = 0
  
  mnl_settings = list(        
    alternatives = c(nor=0, acc=1, brk=2),
    avail        = list(nor=norm_avail, acc=accr_avail, brk=brek_avail), 
    choiceVar    = target,          
    V            = V)
  
  P[["model"]] = apollo_mnl(mnl_settings, functionality)  
  P = apollo_panelProd(P, apollo_inputs, functionality)
  P = apollo_prepareProb(P, apollo_inputs, functionality)  
  return(P)
}


Model2 = apollo_estimate(apollo_beta,
                         apollo_fixed,
                         apollo_probabilities,
                         apollo_inputs)

apollo_modelOutput(Model2)
apollo_saveOutput(Model2)

Model2$LL0
Model2$LLout

hist(Model2$avgCP)

forecast2 <- apollo_prediction(Model2, apollo_probabilities, apollo_inputs)
hist(forecast2$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecast2

estimate_selection_correction <- function(Pk) {
  
  # Inverse of the cumulative distribution function (CDF)
  #https://www.stat.umn.edu/geyer/old/5101/rlook.html#:~:text=qnorm%20is%20the%20R%20function,quantile%20of%20the%20normal%20distribution.
  
  inv_cdf <- qnorm(Pk)
  
  # Calculate the density function for the inverse CDF values
  density <- dnorm(inv_cdf)
  
  # Calculate the term
  selection_correction <- density / Pk
  
  # Return as a list
  result <- list("inv_cdf" = inv_cdf, "density" = density, "selection_correction" = selection_correction)
  
  return(result)
  
}

result_nor <- estimate_selection_correction(data$nor)
result_acc <- estimate_selection_correction(data$acc)
result_brk <- estimate_selection_correction(data$brk)


################# Calculating the Φ−1(Pk) term values for our 3 alternatives

data <- data %>%
  mutate(inv_cdf_nor = result_nor$inv_cdf)

data <- data %>%
  mutate(inv_cdf_acc = result_acc$inv_cdf)

data <- data %>%
  mutate(inv_cdf_brk = result_brk$inv_cdf)

################# Calculating the φ(Φ−1(Pk)) term values for our 3 alternatives

data <- data %>%
  mutate(density_nor = result_nor$density)

data <- data %>%
  mutate(density_acc = result_acc$density)

data <- data %>%
  mutate(density_brk = result_brk$density)

################# Calculating the selection correction regressor φ(Φ−1(Pk))/Pk term values for our 3 alternatives

data <- data %>%
  mutate(selection_correction_nor = result_nor$selection_correction)

data <- data %>%
  mutate(selection_correction_acc = result_acc$selection_correction)

data <- data %>%
  mutate(selection_correction_brk = result_brk$selection_correction)


# Print the updated table
print(data)

################### Step 2.1 / Putting all data in one data.frame

# Combine database and data
# Add all specified columns from data to database
database <- cbind(database, data[, c("nor", "acc", "brk", "chosen", "inv_cdf_nor", "inv_cdf_acc", "inv_cdf_brk", "density_nor", "density_acc", "density_brk", "selection_correction_nor", "selection_correction_acc", "selection_correction_brk")])

################### Step 3 / Using the ols function to create a linear model

# Create the linear model using lm()

database_cleaned <- database[-c(5229,5237, 5236, 5748, 5747, 1648, 1647, 5253, 1651, 5032, 5238, 3274, 5584), ]

#sqr_d_ahead = sqrt(database_cleaned$dist_ahead * database_cleaned$veh_flag)

d_ahead = database_cleaned$dist_ahead * database_cleaned$veh_flag

Model2lm <- lm(gps_speed ~ d_ahead + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

library(performance)
library(qqplotr)

check_result <- check_model(Model2lm)
print(check_result)

beta <- coef(Model2lm)["num_of_det_vehicles"]

summary(Model2lm)
############## likelihood ratio test ###############################

library(lmtest)

# Perform the likelihood ratio test
lrtest_result1 <- lrtest(Basemodeldf, Model1)
lrtest_result2 <- lrtest(Model1, Model2)

print(lrtest_result1)
print(lrtest_result2)

#print(paste("LR Test between Basemodeldf and Model1:\n", lrtest_result1))
#print(paste("\nLR Test between Model1 and Model2:\n", lrtest_result2))