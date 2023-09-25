#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd
import statsmodels.api as sm
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

# Load the dataset
database_cleaned = pd.read_csv("database_cleaned.csv")

# Display the first few rows of the dataset
database_cleaned.head()


# In[2]:


# Define the predictors and response variable
X = database_cleaned[['target_lag1', 'target_lag_diff2', 'target_lag_diff3', 'target_lag_diff4', 
                      'num_of_det_vehicles_diff1', 'num_of_det_vehicles_diff2', 'num_of_det_vehicles_diff3', 
                      'num_of_det_vehicles_diff4', 'is_drowsy', 'is_aggressive', 'num_of_det_vehicles', 
                      'selection_correction_acc', 'selection_correction_nor', 'selection_correction_brk']]
X = sm.add_constant(X)  # Adding a constant for the intercept
y = database_cleaned['gps_speed']


# In[3]:


# Check for missing values excluding the 'const' column
missing_values_excluding_const = database_cleaned[X.columns[1:].tolist() + ['gps_speed']].isnull().sum()

missing_values_excluding_const


# In[4]:


# Drop rows with NaN values
database_cleaned = database_cleaned.dropna(subset=X.columns[1:].tolist() + ['gps_speed'])

# Refit the linear regression model
X_cleaned = database_cleaned[X.columns[1:].tolist()]
X_cleaned = sm.add_constant(X_cleaned)
y_cleaned = database_cleaned['gps_speed']

LagModel8_1lm_cleaned = sm.OLS(y_cleaned, X_cleaned).fit()

# Display the model summary
LagModel8_1lm_cleaned.summary()


# In[5]:


# Posterior Predictive Check: Observed vs Predicted values
predicted_values = LagModel8_1lm_cleaned.predict(X_cleaned)
residuals = y_cleaned - predicted_values


# In[6]:


# 1. Residuals vs Fitted
plt.figure(figsize=(10, 6))
plt.scatter(predicted_values, residuals, color='#1B6CA8', alpha=0.5, marker='.')
plt.axhline(y=0, color='#3AAF85', linestyle='--')
plt.xlabel("Fitted values", fontsize=20)
plt.ylabel("Residuals", fontsize=20)
plt.title("Residuals vs Fitted", fontsize=20)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.tight_layout()
plt.show()


# In[7]:


plt.figure(figsize=(10, 6))
sm.qqplot(residuals, fit=True, line='45', color='#1B6CA8', marker='.', alpha=0.5)
plt.title("Normal Q-Q", fontsize=20)
plt.xlabel("Theoretical Quantiles", fontsize=20)
plt.ylabel("Sample Quantiles", fontsize=20)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)

# Manually adding the 45-degree line with specified color
plt.plot([min(residuals), max(residuals)], [min(residuals), max(residuals)], color='#3AAF85', linestyle='--', lw=2)

plt.tight_layout()
plt.show()


# In[8]:


standardized_residuals = residuals / residuals.std()


# In[9]:


# 3. Scale-Location (Spread-Location) plot with smoothed line
plt.figure(figsize=(10, 6))

# Scatter plot
plt.scatter(predicted_values, np.sqrt(np.abs(standardized_residuals)), color='#1B6CA8', alpha=0.5, marker='.')

# Adding a smoothed line
sns.regplot(predicted_values, np.sqrt(np.abs(standardized_residuals)), scatter=False, lowess=True, color='#3AAF85', line_kws={'linewidth': 2})

plt.xlabel("Fitted values", fontsize=20)
plt.ylabel("√|Standardized Residuals|", fontsize=20)
plt.title("Scale-Location", fontsize=20)
plt.xticks(fontsize=20)
plt.yticks(fontsize=20)
plt.tight_layout()
plt.show()


# In[10]:


# Getting influence and leverage values
influence = LagModel8_1lm_cleaned.get_influence()
leverage = influence.hat_matrix_diag
cooks_d = influence.cooks_distance[0]


# In[12]:


# Residuals vs Leverage plot with manually added Cook's distance lines
fig, ax = plt.subplots(figsize=(10, 6))

# Scatter plot of residuals vs leverage
ax.scatter(leverage, standardized_residuals, color='#1B6CA8', alpha=0.5, marker='.')

# Adding Cook's distance contours
n = len(predicted_values)
p = X_cleaned.shape[1]
cooks_threshold = 4 / n
leverage_threshold = 3 * (p + 1) / n

# Highlighting influential points based on Cook's distance
influential_points = np.where(cooks_d > cooks_threshold)[0]
ax.scatter(leverage[influential_points], standardized_residuals.iloc[influential_points], color='red', s=75, edgecolors='black', alpha=0.7)

# Drawing lines for Cook's distance and leverage thresholds
ax.axhline(y=0, color='black', linestyle='--')
ax.axhline(y=2, color='grey', linestyle='--')
ax.axhline(y=-2, color='grey', linestyle='--')
ax.axvline(x=leverage_threshold, color='grey', linestyle='--')

# Customizing the plot
ax.set_title("Residuals vs Leverage", fontsize=20)
ax.set_xlabel("Leverage", fontsize=20)
ax.set_ylabel("Standardized Residuals", fontsize=20)

# Displaying the plot
plt.tight_layout()
plt.show()

