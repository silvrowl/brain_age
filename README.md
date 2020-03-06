## brain_age

Research to evaluate the performance of various machine learning models used to predict a person's brain age from a multitude of fMRI based biomarkers and cognitive behavioral performance.

Overview of the results: [link](https://drive.google.com/file/d/1Kg4D3cPZRcUF_NyETmu5_LwXXcVOb1Wh/view)

## Prerequisites

All functions are written in matlab. 

## Description of Analysis

The brain age of around 100 healthy adults participants across all ages was predicted using behavioral measures compiled in using a series of coginitive tests, their functional connectivity profiles computed using [CONN](https://www.nitrc.org/projects/conn/) and each person's fMRI data, as well as grey matter and white matter biomarkers computed using [Freesurfer](https://surfer.nmr.mgh.harvard.edu/), which is also derived from each person's fMRI data. A number of regression models were created and compared to see how they handle a low number of subjects and many features. 

These included:

- Quadratic Model Regression
- General Linear Model Regression
- Partial Least Squares Regression
- Random Forest Regression
- Support Vector Regression

Prediction was achieved using a nested cross validation structure to prevent over fitting. It was found that Support Vector Regression and Partial Least Squares Regression were able to outperform the other methods, achieving an average error of 7.4 years between the subjects real age and thier predicted age. 

Data is not included here for patient confidentiality reasons

## Files

age_predict_master.m - Script to run all models

/model_functions - Scripts for each model type
	- nested_fcn_quadratic_model_February_7_2019.m 
	- nested_fcn_linear_model_February_7_2019.m        
	- nested_fcn_pls_model_December_18_2018.m     
	- nested_fcn_random_forest_model_December_18_2018.m       
	- nested_fcn_svmr_model_December_18_2018.m                   
	     
/plotting_code - Scripts to plot the results created by above
	- age_predict_master_plot.m  
	- glm_plot.m  
	- lasso_plot.m  
	- pls_plot_commented.m  
	- pls_plot.m  
	- rf_plot.m  
	- svmr_plot.m

