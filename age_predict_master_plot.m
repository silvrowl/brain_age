
clear
close all

load('subj_id.mat')
n_obs_trim = 93 ; 

load('reps_results_rmis_fit_svm.mat');
load('reps_results_rmis_act_svm.mat');
load('reps_results_rmis_subj_svm.mat');

load('reps_results_rmis_fit_pls.mat');
load('reps_results_rmis_act_pls.mat');
load('reps_results_rmis_subj_pls.mat');

load('reps_results_rmis_fit_rf.mat');
load('reps_results_rmis_act_rf.mat');
load('reps_results_rmis_subj_rf.mat');

load('reps_results_rmis_fit_lin.mat');
load('reps_results_rmis_act_lin.mat');
load('reps_results_rmis_subj_lin.mat');

M1 = csvread('subj_id.csv') ; 
M2 = csvread('real_ages.csv') ; 
M3 = csvread('pred_ages.csv') ; 

reps_results_fit_las = M3 ; 
reps_results_act_las = M2 ; 
reps_results_subj_las = M1 ; 

z=50 ; 
cntr=1 ; 

for d = 1:z

    %SVMR
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_svm(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_svm(d,sub_ind) ; 
       fit =  reps_results_fit_svm(d,sub_ind) ; 
       fit_mean_val_svm(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    svm_error = mean(abs(fit_mean_val_svm-act_val)) ;
    
    rep_score(cntr) = svm_error  ; 
    g_matrix(cntr) = 1 ; 
    rep_cnt(cntr) = d ; 
    cntr=cntr+1 ; 
    
    %Lasso
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_las(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_las(d,sub_ind) ; 
       fit =  reps_results_fit_las(d,sub_ind) ; 
       fit_mean_val_las(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    las_error_rand = mean(abs(fit_mean_val_las-act_val)) ;
    
    rep_score(cntr) = las_error_rand  ; 
    g_matrix(cntr) = 3 ; 
    rep_cnt(cntr) = d ; 
    cntr=cntr+1 ; 
    
    %PLS
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_pls(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_pls(d,sub_ind) ; 
       fit =  reps_results_fit_pls(d,sub_ind) ; 
       fit_mean_val_pls(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    pls_error_rand = mean(abs(fit_mean_val_pls-act_val)) ;
    
    rep_score(cntr) = pls_error_rand  ; 
    g_matrix(cntr) = 2 ; 
    rep_cnt(cntr) = d ; 
    cntr=cntr+1 ; 
    
    %Random Forest
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_rf(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_rf(d,sub_ind) ; 
       fit =  reps_results_fit_rf(d,sub_ind) ; 
       fit_mean_val_rf(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    rf_error = mean(abs(fit_mean_val_rf-act_val)) ;
    
    rep_score(cntr) = rf_error  ; 
    g_matrix(cntr) = 4 ; 
    rep_cnt(cntr) = d ; 
    cntr=cntr+1 ; 
    
    %General Linear Model
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_lin(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_lin(d,sub_ind) ; 
       fit =  reps_results_fit_lin(d,sub_ind) ; 
       fit_mean_val_lin(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    lin_error = mean(abs(fit_mean_val_lin-act_val)) ;
    
    rep_score(cntr) = lin_error  ; 
    g_matrix(cntr) = 5 ; 
    rep_cnt(cntr) = d ; 
    cntr=cntr+1 ; 

end

boxplot(rep_score,g_matrix)