% Support Vector Machine plots

clear
close all

load('subj_id.mat')
n_obs_trim = 93 ; 

M1 = csvread('subj_id.csv') ; 
M2 = csvread('real_ages.csv') ; 
M3 = csvread('pred_ages.csv') ; 

reps_results_fit_las = M3 ; 
reps_results_act_las = M2 ; 
reps_results_subj_las = M1 ; 

z=50 ; 
cntr=1 ; 

hold on 
plot(20:90,20:90) ;
for d = 1:z
    d    
    %SVMR
    for s=1:n_obs_trim    
       sub_ind = reps_results_subj_las(d,:)==subj_id(s)  ;     
       actual =  reps_results_act_las(d,sub_ind) ; 
       fit =  reps_results_fit_las(d,sub_ind) ; 
       fit_mean_val_las(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    all_points(d,:) = fit_mean_val_las  ; 
    
    svm_error = mean(abs(fit_mean_val_las-act_val)) ;
    
     
    %scatter(act_val,fit_mean_val_svm) ;       
    %xlabel('Actual')
    %ylabel('Prediction')
    %title(' SVM Regression All Repetitions ')
   
    
    %rep_score(cntr) = svm_error  ; 
    cntr=cntr+1 ; 
    
end 
 
 hold off
 
 mean_all = mean(all_points,1) ; 
 stderror = std(all_points,1)  ;
 
 close all
 hold on 
 
 scatter(act_val,mean_all) ; 
 plot(20:90,20:90) ;
 %err = 2*ones(1,size(act_val,2));
 e = errorbar(act_val, mean_all, stderror,'o');
 e.Color = 'blue' ; 
 xlabel('Actual')
 ylabel('Prediction')
 title(' PCA/LASSO Regression ')
 
 hold off
%  
%  
%  %Subjectwise error
%  
% error_subject = (mean_all-act_val) ;
%  
% compare = [ subj_id act_val' mean_all' error_subject'  ] 
% 
% save('subject_compare_svm.mat','compare') ; 
 
 