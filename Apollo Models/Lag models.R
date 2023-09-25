database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
database

############################## Creating target lag columns ###########################################################

# target lag 2
library(dplyr)
library(zoo)

# Create target_lag2 column
database <- database %>%
  mutate(target_lag_diff2 = lag(target, 2, default = 0))

# target lag 3
library(dplyr)

# Create target_lag3 column
database <- database %>%
  mutate(target_lag_diff3 = lag(target, 3, default = 0))

library(dplyr)
library(zoo)

# Create target_lag4 column
database <- database %>%
  mutate(target_lag_diff4 = lag(target, 4, default = 0))

library(dplyr)
library(zoo)

# Create target_lag_avg2 column
database <- database %>%
  mutate(avg_prev_tg_diff2 = rollmean(target, k = 2, fill = 0, align = "right")) %>%
  mutate(target_lag_avg_diff2 = lag(avg_prev_tg_diff2, 1, default = 0))

# Create target_lag_avg3 column
database <- database %>%
  mutate(avg_prev_tg_diff3 = rollmean(target, k = 3, fill = 0, align = "right")) %>%
  mutate(target_lag_avg_diff3 = lag(avg_prev_tg_diff3, 1, default = 0))

# Create target_lag_avg4 column
database <- database %>%
  mutate(avg_prev_tg_diff4 = rollmean(target, k = 4, fill = 0, align = "right")) %>%
  mutate(target_lag_avg_diff4 = lag(avg_prev_tg_diff4, 1, default = 0))

#Take the max of the last 2 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(target_lag_max2 = lag(rollapply(target, width = 2, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 3 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(target_lag_max3 = lag(rollapply(target, width = 3, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(target_lag_max4 = lag(rollapply(target, width = 4, FUN = max, align = "right", fill = 0), default = 0))


############################## Creating gps speed diff lag columns ###########################################################

# gps_speed 2
library(dplyr)
library(zoo)

# Create gps_speed2 column
database <- database %>%
  mutate(gps_speed_diff2 = lag(gps_speed, 2, default = 0))

library(dplyr)

# Create gps_speed3 column
database <- database %>%
  mutate(gps_speed_diff3 = lag(gps_speed, 3, default = 0))

library(dplyr)
library(zoo)

# Create gps_speed4 column
database <- database %>%
  mutate(gps_speed_diff4 = lag(gps_speed, 4, default = 0))

library(dplyr)
library(zoo)

# Create gps_speed2 column
database <- database %>%
  mutate(avg_gpsprev_diff2 = rollmean(gps_speed, k = 2, fill = 0, align = "right")) %>%
  mutate(gps_speed_avg_diff2 = lag(avg_gpsprev_diff2, 1, default = 0))

library(dplyr)
library(zoo)

# Create gps_speed3 column
database <- database %>%
  mutate(avg_gpsprev_diff3 = rollmean(gps_speed, k = 3, fill = 0, align = "right")) %>%
  mutate(gps_speed_avg_diff3 = lag(avg_gpsprev_diff3, 1, default = 0))

library(dplyr)
library(zoo)

# Create gps_speed4 column
database <- database %>%
  mutate(avg_gpsprev_diff4 = rollmean(gps_speed, k = 4, fill = 0, align = "right")) %>%
  mutate(gps_speed_avg_diff4 = lag(avg_gpsprev_diff4, 1, default = 0))

#Take the max of the last 2 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(gps_speed_diff_max2 = lag(rollapply(gps_speed, width = 2, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(gps_speed_diff_max3 = lag(rollapply(gps_speed, width = 3, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(gps_speed_diff_max4 = lag(rollapply(gps_speed, width = 4, FUN = max, align = "right", fill = 0), default = 0))

############################## Creating no of det veh lag columns ###########################################################

library(dplyr)
library(zoo)

# Create num_of_det_vehicles2 column
database <- database %>%
  mutate(num_of_det_vehicles_diff1 = lag(num_of_det_vehicles, 1, default = 0))


library(dplyr)
library(zoo)

# Create num_of_det_vehicles2 column
database <- database %>%
  mutate(num_of_det_vehicles_diff2 = lag(num_of_det_vehicles, 2, default = 0))

library(dplyr)

# Create num_of_det_vehicles3 column
database <- database %>%
  mutate(num_of_det_vehicles_diff3 = lag(num_of_det_vehicles, 3, default = 0))

library(dplyr)
library(zoo)

# Create num_of_det_vehicles4 column
database <- database %>%
  mutate(num_of_det_vehicles_diff4 = lag(num_of_det_vehicles, 4, default = 0))

library(dplyr)
library(zoo)

# Create num_of_det_vehicles_diff_avg2 column
database <- database %>%
  mutate(avg_prev_nodv_diff2 = rollmean(num_of_det_vehicles, k = 2, fill = 0, align = "right")) %>%
  mutate(num_of_det_vehicles_diff_avg2 = lag(avg_prev_nodv_diff2, 1, default = 0))

library(dplyr)
library(zoo)

# Create num_of_det_vehicles_diff_avg3 column
database <- database %>%
  mutate(avg_prev_nodv_diff3 = rollmean(num_of_det_vehicles, k = 3, fill = 0, align = "right")) %>%
  mutate(num_of_det_vehicles_diff_avg3 = lag(avg_prev_nodv_diff3, 1, default = 0))

library(dplyr)
library(zoo)

# Create num_of_det_vehicles_diff_avg4 column
database <- database %>%
  mutate(avg_prev_nodv_diff4 = rollmean(num_of_det_vehicles, k = 4, fill = 0, align = "right")) %>%
  mutate(num_of_det_vehicles_diff_avg4 = lag(avg_prev_nodv_diff4, 1, default = 0))

#Take the max of the last 2 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(num_of_det_vehicles_diff_max2 = lag(rollapply(num_of_det_vehicles, width = 2, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 3 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(num_of_det_vehicles_diff_max3 = lag(rollapply(num_of_det_vehicles, width = 3, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'num_of_det_vehicles_diff_max4'
database <- database %>%
  mutate(num_of_det_vehicles_diff_max4 = lag(rollapply(num_of_det_vehicles, width = 4, FUN = max, align = "right", fill = 0), default = 0))


############################## Creating dist ahead lag columns ###########################################################

library(dplyr)
library(zoo)

# Create dist_ahead1 column
database <- database %>%
  mutate(dist_ahead_diff1 = lag(dist_ahead, 1, default = 0))

library(dplyr)
library(zoo)

# Create v2 column
database <- database %>%
  mutate(dist_ahead_diff2 = lag(dist_ahead, 2, default = 0))

library(dplyr)

# Create dist_ahead3 column
database <- database %>%
  mutate(dist_ahead_diff3 = lag(dist_ahead, 3, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead4 column
database <- database %>%
  mutate(dist_ahead_diff4 = lag(dist_ahead, 4, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg2 column
database <- database %>%
  mutate(avg_prev_distahead_diff2 = rollmean(dist_ahead, k = 2, fill = 0, align = "right")) %>%
  mutate(dist_ahead_diff_avg2 = lag(avg_prev_distahead_diff2, 1, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg3 column
database <- database %>%
  mutate(avg_prev_distahead_diff3 = rollmean(dist_ahead, k = 3, fill = 0, align = "right")) %>%
  mutate(dist_ahead_diff_avg3 = lag(avg_prev_distahead_diff3, 1, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg4 column
database <- database %>%
  mutate(avg_prev_distahead_diff4 = rollmean(dist_ahead, k = 4, fill = 0, align = "right")) %>%
  mutate(dist_ahead_diff_avg4 = lag(avg_prev_distahead_diff4, 1, default = 0))

#Take the max of the last 2 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(dist_ahead_diff_max2 = lag(rollapply(dist_ahead, width = 2, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 3 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(dist_ahead_diff_max3 = lag(rollapply(dist_ahead, width = 3, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'num_of_det_vehicles_diff_max4'
database <- database %>%
  mutate(dist_ahead_diff_max4 = lag(rollapply(dist_ahead, width = 4, FUN = max, align = "right", fill = 0), default = 0))


############################## Creating veh_flag lag columns ###########################################################

library(dplyr)
library(zoo)

# Create dist_ahead1 column
database <- database %>%
  mutate(veh_flag_diff1 = lag(veh_flag, 1, default = 0))

library(dplyr)
library(zoo)

# Create v2 column
database <- database %>%
  mutate(veh_flag_diff2 = lag(veh_flag, 2, default = 0))

library(dplyr)

# Create dist_ahead3 column
database <- database %>%
  mutate(veh_flag_diff3 = lag(veh_flag, 3, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead4 column
database <- database %>%
  mutate(veh_flag_diff4 = lag(veh_flag, 4, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg2 column
database <- database %>%
  mutate(avg_prev_veh_flag_diff2 = rollmean(veh_flag, k = 2, fill = 0, align = "right")) %>%
  mutate(veh_flag_diff_avg2 = lag(avg_prev_veh_flag_diff2, 1, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg3 column
database <- database %>%
  mutate(avg_prev_veh_flag_diff3 = rollmean(veh_flag, k = 3, fill = 0, align = "right")) %>%
  mutate(veh_flag_diff_avg3 = lag(avg_prev_veh_flag_diff3, 1, default = 0))

library(dplyr)
library(zoo)

# Create dist_ahead_diff_avg4 column
database <- database %>%
  mutate(avg_prev_veh_flag_diff4 = rollmean(veh_flag, k = 4, fill = 0, align = "right")) %>%
  mutate(veh_flag_diff_avg4 = lag(avg_prev_veh_flag_diff4, 1, default = 0))

#Take the max of the last 2 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(veh_flag_diff_max2 = lag(rollapply(veh_flag, width = 2, FUN = max, align = "right", fill = 0), default = 0))

#Take the max of the last 3 lag

library(dplyr)
library(zoo)

# Create a new column 'lag_max'
database <- database %>%
  mutate(veh_flag_diff_max3 = lag(rollapply(veh_flag, width = 3, FUN = max, align = "right", fill = 0), default =0))

#Take the max of the last 4 lag

library(dplyr)
library(zoo)

# Create a new column 'num_of_det_vehicles_diff_max4'
database <- database %>%
  mutate(veh_flag_diff_max4 = lag(rollapply(veh_flag, width = 4, FUN = max, align = "right", fill = 9999), default = 9999))

################ Checking the created columns ###############################

# View columns 49 to 105
selected_columns <- database[, 49:105]

# Print the selected columns
print(selected_columns)
############################## Lag Model 8: Taking the first,second, third and fourth order lag ###############################################

library(apollo)
library(foreign)
apollo_initialise()

#database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
#database

apollo_control=list(modelName  ="LagModel_8",
                    modelDescr ="Computing the discrete continuous model with the first,second, third and fourth order lags",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output/lagmodel"
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
              b_lag_1            = 0,
              b_lag_2            = 0,
              b_lag_3            = 0,
              b_lag_4            = 0,
              nodv_lag_acc1      = 0,
              nodv_lag_acc2      = 0,
              nodv_lag_acc3      = 0,
              nodv_lag_acc4      = 0,
              nodv_lag_brk1      = 0,
              nodv_lag_brk2      = 0,
              nodv_lag_brk3      = 0,
              nodv_lag_brk4      = 0,
              dist_lag_acc1      = 0,
              dist_lag_acc2      = 0,
              dist_lag_acc3      = 0,
              dist_lag_acc4      = 0,
              dist_lag_brk1      = 0,
              dist_lag_brk2      = 0,
              dist_lag_brk3      = 0,
              dist_lag_brk4      = 0
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
  
  target_lag1_acc = target_lag1 == 1
  target_lag1_brk = target_lag1 == 2
  
  target_lag2_acc = target_lag_diff2 == 1
  target_lag2_brk = target_lag_diff2 == 2
  
  target_lag3_acc = target_lag_diff3 == 1
  target_lag3_brk = target_lag_diff3 == 2
  
  target_lag4_acc = target_lag_diff4 == 1
  target_lag4_brk = target_lag_diff4 == 2
  
  d_ahead = dist_ahead * veh_flag
  d_ahead_lag1 = dist_ahead_diff1 * veh_flag_diff1
  d_ahead_lag2 = dist_ahead_diff2 * veh_flag_diff2
  d_ahead_lag3 = dist_ahead_diff3 * veh_flag_diff3
  d_ahead_lag4 = dist_ahead_diff4 * veh_flag_diff4

  V[["acc"]]  = asc_acc + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles + time_to_impact_acc * time_to_impact + is_drowsy_acc * is_drowsy + is_aggressive_acc * is_aggressive + b_lag_1 * target_lag1_acc + b_lag_2 * target_lag2_acc + b_lag_3 * target_lag3_acc + b_lag_4 * target_lag4_acc + nodv_lag_acc1 * num_of_det_vehicles_diff1 + nodv_lag_acc2 * num_of_det_vehicles_diff2 + nodv_lag_acc3 * num_of_det_vehicles_diff3 + nodv_lag_acc4 * num_of_det_vehicles_diff4 + dist_lag_acc1 * d_ahead_lag1 + dist_lag_acc2 * d_ahead_lag2 + dist_lag_acc3 * d_ahead_lag3 + dist_lag_acc4 * d_ahead_lag4 
  V[["brk"]]  = asc_brk + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles + time_to_impact_brk * time_to_impact + is_drowsy_brk * is_drowsy + is_aggressive_brk * is_aggressive + b_lag_1 * target_lag1_brk + b_lag_2 * target_lag2_brk + b_lag_3 * target_lag3_brk + b_lag_4 * target_lag4_brk + nodv_lag_brk1 * num_of_det_vehicles_diff1 + nodv_lag_brk2 * num_of_det_vehicles_diff2 + nodv_lag_brk3 * num_of_det_vehicles_diff3 + nodv_lag_brk4 * num_of_det_vehicles_diff4 + dist_lag_brk1 * d_ahead_lag1 + dist_lag_brk2 * d_ahead_lag2 + dist_lag_brk3 * d_ahead_lag3 + dist_lag_brk4 * d_ahead_lag4
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


LagModel_8 = apollo_estimate(apollo_beta,
                         apollo_fixed,
                         apollo_probabilities,
                         apollo_inputs)

apollo_modelOutput(LagModel_8)
apollo_saveOutput(LagModel_8)

LagModel_8$LL0
LagModel_8$LLout

hist(LagModel_8$avgCP)

forecastlag_8 <- apollo_prediction(LagModel_8, apollo_probabilities, apollo_inputs)
hist(forecastlag_8$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecastlag_8

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

LagModel8_1lm <- lm(gps_speed ~ target_lag1 + target_lag_diff2 + target_lag_diff3 + target_lag_diff4 + num_of_det_vehicles_diff1 + num_of_det_vehicles_diff2 + num_of_det_vehicles_diff3 + num_of_det_vehicles_diff4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

#LagModel8_2lm <- lm(gps_speed_diff1 + gps_speed_diff2 + gps_speed_diff3 + gps_speed_diff4  ~ target_lag1 + target_lag_diff2 + target_lag_diff3 + target_lag_diff4 + num_of_det_vehicles_diff1 + num_of_det_vehicles_diff2 + num_of_det_vehicles_diff3 + num_of_det_vehicles_diff4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

library(performance)
library(qqplotr)

check_result <- check_model(LagModel8_1lm)
print(check_result)

beta <- coef(LagModel8_1lm)["num_of_det_vehicles"]

beta

summary(LagModel8_1lm)

#summary(LagModel8_2lm)

############################## Lag Model 9: Taking the avg of first,second, third and fourth order lag ###############################################

library(apollo)
library(foreign)
apollo_initialise()

#database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
#database

apollo_control=list(modelName  ="LagModel_9",
                    modelDescr ="Computing the discrete continuous model with the average of first,second, third and fourth order lags",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output/lagmodel"
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
              nodv_lag_acc_avg2  = 0,
              nodv_lag_acc_avg3  = 0,
              nodv_lag_acc_avg4  = 0,
              nodv_lag_brk_avg2  = 0,
              nodv_lag_brk_avg3  = 0,
              nodv_lag_brk_avg4  = 0,
              dist_ahead_acc_avg2  = 0,
              dist_ahead_acc_avg3  = 0,
              dist_ahead_acc_avg4  = 0,
              dist_ahead_brk_avg2  = 0,
              dist_ahead_brk_avg3  = 0,
              dist_ahead_brk_avg4  = 0
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
  
  d_ahead = dist_ahead * veh_flag
  d_ahead_avg_lag2 = dist_ahead_diff_avg2 * veh_flag_diff_avg2
  d_ahead_avg_lag3 = dist_ahead_diff_avg3 * veh_flag_diff_avg3
  d_ahead_avg_lag4 = dist_ahead_diff_avg4 * veh_flag_diff_avg4
  
  V[["acc"]]  = asc_acc + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles + time_to_impact_acc * time_to_impact + is_drowsy_acc * is_drowsy + is_aggressive_acc * is_aggressive + nodv_lag_acc_avg2 * num_of_det_vehicles_diff_avg2 + nodv_lag_acc_avg3 * num_of_det_vehicles_diff_avg3 + nodv_lag_acc_avg4 * num_of_det_vehicles_diff_avg4 + dist_ahead_acc_avg2 * d_ahead_avg_lag2 + dist_ahead_acc_avg3 * d_ahead_avg_lag3 + dist_ahead_acc_avg4 * d_ahead_avg_lag4
  V[["brk"]]  = asc_brk + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles + time_to_impact_brk * time_to_impact + is_drowsy_brk * is_drowsy + is_aggressive_brk * is_aggressive + nodv_lag_brk_avg2 * num_of_det_vehicles_diff_avg2 + nodv_lag_brk_avg3 * num_of_det_vehicles_diff_avg3 + nodv_lag_brk_avg4 * num_of_det_vehicles_diff_avg4 + dist_ahead_brk_avg2 * d_ahead_avg_lag2 + dist_ahead_brk_avg3 * d_ahead_avg_lag3 + dist_ahead_brk_avg4 * d_ahead_avg_lag4
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


LagModel_9 = apollo_estimate(apollo_beta,
                             apollo_fixed,
                             apollo_probabilities,
                             apollo_inputs)

apollo_modelOutput(LagModel_9)
apollo_saveOutput(LagModel_9)

LagModel_9$LL0
LagModel_9$LLout

hist(LagModel_9$avgCP)

forecastlag_9 <- apollo_prediction(LagModel_9, apollo_probabilities, apollo_inputs)
hist(forecastlag_9$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecastlag_9

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

LagModel9_1lm <- lm(gps_speed ~ num_of_det_vehicles_diff_avg2 + num_of_det_vehicles_diff_avg3 + num_of_det_vehicles_diff_avg4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

#LagModel9_2lm <- lm(gps_speed_diff1 + gps_speed_diff2 + gps_speed_diff3 + gps_speed_diff4  ~ target_lag1 + target_lag_diff2 + target_lag_diff3 + target_lag_diff4 + num_of_det_vehicles_diff1 + num_of_det_vehicles_diff2 + num_of_det_vehicles_diff3 + num_of_det_vehicles_diff4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

library(performance)
library(qqplotr)

check_result <- check_model(LagModel_9lm)
print(check_result)

beta <- coef(LagModel_9lm)["num_of_det_vehicles"]

summary(LagModel9_1lm)

#summary(LagModel9_2lm)

############################## Lag Model 10: Taking the max of first,second, third and fourth order lag ###############################################

library(apollo)
library(foreign)
apollo_initialise()

#database <- read.csv("laggedchoice_data_car_driver_choices_cleaned.csv")
#database

apollo_control=list(modelName  ="LagModel_10",
                    modelDescr ="Computing the discrete continuous model with the max of first,second, third and fourth order lags",
                    indivID    ="driver_tag",
                    workInLogs = TRUE,
                    outputDirectory = "output/lagmodel"
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
              nodv_lag_acc_max2  = 0,
              nodv_lag_acc_max3  = 0,
              nodv_lag_acc_max4  = 0,
              nodv_lag_brk_max2  = 0,
              nodv_lag_brk_max3  = 0,
              nodv_lag_brk_max4  = 0,
              dist_ahead_acc_max2  = 0,
              dist_ahead_acc_max3  = 0,
              dist_ahead_acc_max4  = 0,
              dist_ahead_brk_max2  = 0,
              dist_ahead_brk_max3  = 0,
              dist_ahead_brk_max4  = 0
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
  
  #time_of_impact = (dist_ahead/gps_speed) * veh_flag
  
  time_to_impact = (dist_ahead/gps_speed) * veh_flag
  
  d_ahead = dist_ahead * veh_flag
  
  d_ahead = dist_ahead * veh_flag
  d_ahead_max_lag2 = dist_ahead_diff_max2 * veh_flag_diff_max2
  d_ahead_max_lag3 = dist_ahead_diff_max3 * veh_flag_diff_max3
  d_ahead_max_lag4 = dist_ahead_diff_max4 * veh_flag_diff_max4
  
  V[["acc"]]  = asc_acc + dist_acc * d_ahead + nodv_acc * num_of_det_vehicles + time_to_impact_acc * time_to_impact + is_drowsy_acc * is_drowsy + is_aggressive_acc * is_aggressive + nodv_lag_acc_max2 * num_of_det_vehicles_diff_max2 + nodv_lag_acc_max3 * num_of_det_vehicles_diff_max3 + nodv_lag_acc_max4 * num_of_det_vehicles_diff_max4 + dist_ahead_acc_max2 * d_ahead_max_lag2 + dist_ahead_acc_max3 * d_ahead_max_lag3 + dist_ahead_acc_max4 * d_ahead_max_lag4
  V[["brk"]]  = asc_brk + dist_brk * d_ahead + nodv_brk * num_of_det_vehicles + time_to_impact_brk * time_to_impact + is_drowsy_brk * is_drowsy + is_aggressive_brk * is_aggressive + nodv_lag_brk_max2 * num_of_det_vehicles_diff_max2 + nodv_lag_brk_max3 * num_of_det_vehicles_diff_max3 + nodv_lag_brk_max4 * num_of_det_vehicles_diff_max4 + dist_ahead_brk_max2 * d_ahead_max_lag2 + dist_ahead_brk_max3 * d_ahead_max_lag3 + dist_ahead_brk_max4 * d_ahead_max_lag4
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

LagModel_10 = apollo_estimate(apollo_beta,
                             apollo_fixed,
                             apollo_probabilities,
                             apollo_inputs)

apollo_modelOutput(LagModel_10)
apollo_saveOutput(LagModel_10)

LagModel_10$LL0
LagModel_10$LLout

hist(LagModel_10$avgCP)

forecastlag_10 <- apollo_prediction(LagModel_10, apollo_probabilities, apollo_inputs)
hist(forecastlag_10$chosen)

################# Step2 - the estimates are taken from the previous model

# Load the required libraries
library(dplyr)

data <- forecastlag_10

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

LagModel10_1lm <- lm(gps_speed ~ num_of_det_vehicles_diff_max2 + num_of_det_vehicles_diff_max3 + num_of_det_vehicles_diff_max4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

#LagModel10_2lm <- lm(gps_speed_diff1 + gps_speed_diff2 + gps_speed_diff3 + gps_speed_diff4  ~ target_lag1 + target_lag_diff2 + target_lag_diff3 + target_lag_diff4 + num_of_det_vehicles_diff1 + num_of_det_vehicles_diff2 + num_of_det_vehicles_diff3 + num_of_det_vehicles_diff4 + is_drowsy + is_aggressive + num_of_det_vehicles + selection_correction_acc + selection_correction_nor + selection_correction_brk, data = database_cleaned)

library(performance)
library(qqplotr)

check_result <- check_model(LagModel_9lm)
print(check_result)

beta <- coef(LagModel_9lm)["num_of_det_vehicles"]

summary(LagModel10_1lm)

#summary(LagModel10_2lm)

############## likelihood ratio test ###############################

library(lmtest)

# Perform the likelihood ratio test
lrtest_result_lag1 <- lrtest(LagModel_8, LagModel_9)
lrtest_result_lag2 <- lrtest(LagModel_9, LagModel_10)

print(lrtest_result_lag1)
print(lrtest_result_lag2)