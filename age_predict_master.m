% Script to run 100 repition multiple imputation for 3 different model

%clear

reps = 50; 

for z = 1:29
    
    z
    
    [num txt raw] = xlsread('Final.Spreadsheet.All.Raw.Data.Dan.withage.xlsx') ; 
    
    %Remove Missing Data
    num = rmmissing(num) ; 

    %Assign X and Y 
    subj_id = num(:,1) ; 
    data = num(:,2:end) ; 
    X = zscore(data(:,2:end)) ;
    Y =  (data(:,1)) ; 
    Y_orig = Y ; 
    n_obs = length(data(:,1)) ;     
    
    %%Decide on subjects or variables to remove/transform
    %Subject Outliers

%     for j = 1:221 
% 
%         data = X(:,j) ; 
%         Xj_avg = mean(data) ; 
%         Xj_std = std(data) ; 
% 
%         subj = 1:n_obs ; 
%         is_out(j,:) = abs(data-Xj_avg)>3*Xj_std ; 
%         is_skew(j) = max(data)/min(data+0.001) ; 
% 
%         if abs(is_skew(j))>20
%             X(:,j) = zscore(log(data)) ; 
%             is_skew(j) = max(log(data))/min(log(data)+0.001) ; 
%         end
%     end    

    vars=1:238 ; 
    subj=1:n_obs ; 
    n_obs_trim = size(X,1) ; 
    
    num_for_reps(z) = n_obs_trim ; 
    save('num_for_reps.mat','num_for_reps')
    
    %Run Linear Model
    %[yfit_lin, test_lin, subj_lin ] = nested_fcn_linear_model_February_7_2019(X,Y,subj_id,z) ; 
    
    %Run Quadratic Model
    %[yfit_qd, test_qd, subj_qd ] = nested_fcn_quadratic_model_February_7_2019(X,Y,subj_id,z) ; 
    
    %Run PLS
    [yfit_pls, test_pls, subj_pls ] = nested_fcn_pls_model_December_18_2018(X,Y,subj_id,z) ; 

    %Run SVM    
    %[yfit_svm, test_svm, subj_svm ] = nested_fcn_svmr_model_December_18_2018(X,Y,subj_id,z) ; 

    %Run Random Forest
    %[yfit_rf, test_rf, subj_rf ] = nested_fcn_random_forest_model_December_18_2018(X,Y,subj_id,z) ; 
    
    %error_lin(z) = mean(abs(yfit_lin-test_lin)) ; 
    %error_qd(z) = mean(abs(yfit_qd-test_qd)) ;
    
%     reps_results_fit_lin(z,:) = yfit_lin; 
%     reps_results_act_lin(z,:) =  test_lin;
%     reps_results_subj_lin(z,:) =  subj_lin; 
% 
%     reps_results_fit_qd(z,:) = yfit_qd; 
%     reps_results_act_qd(z,:) =  test_qd;
%     reps_results_subj_qd(z,:) =  subj_qd; 
    
    reps_results_fit_pls(z,:) = yfit_pls; 
    reps_results_act_pls(z,:) =  test_pls;
    reps_results_subj_pls(z,:) =  subj_pls; 
    
%     reps_results_fit_svm(z,:) = yfit_svm;
%     reps_results_act_svm(z,:) = test_svm;  
%     reps_results_subj_svm(z,:) = subj_svm;     
%     
%     reps_results_fit_rf(z,:) = yfit_rf;
%     reps_results_act_rf(z,:) = test_rf;
%     reps_results_subj_rf(z,:) = subj_rf;  
%     
%     save('reps_results_rmis_fit_lin.mat','reps_results_fit_lin')
%     save('reps_results_rmis_act_lin.mat','reps_results_act_lin')
%     save('reps_results_rmis_subj_lin.mat','reps_results_subj_lin')
% 
%     save('reps_results_rmis_fit_qd.mat','reps_results_fit_qd')
%     save('reps_results_rmis_act_qd.mat','reps_results_act_qd')
%     save('reps_results_rmis_subj_qd.mat','reps_results_subj_qd')  
%        
    save('reps_results_rmis_fit_pls.mat','reps_results_fit_pls')
    save('reps_results_rmis_act_pls.mat','reps_results_act_pls')
    save('reps_results_rmis_subj_pls.mat','reps_results_subj_pls')
    
%     save('reps_results_rmis_fit_svm.mat','reps_results_fit_svm')
%     save('reps_results_rmis_act_svm.mat','reps_results_act_svm')
%     save('reps_results_rmis_subj_svm.mat','reps_results_subj_svm')
%     
%     save('reps_results_rmis_fit_rf.mat','reps_results_fit_rf')
%     save('reps_results_rmis_act_rf.mat','reps_results_act_rf')
%     save('reps_results_rmis_subj_rf.mat','reps_results_subj_rf')
    
    save('subj_id.mat','subj_id')
    
end



