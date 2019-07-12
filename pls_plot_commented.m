% Support Vector Machine plots

clear
close all

%Load in Subject list
load('subj_id.mat')
n_obs_trim = 93 ; 

%Load in Data
load('reps_results_rmis_fit_pls.mat');
load('reps_results_rmis_act_pls.mat');
load('reps_results_rmis_subj_pls.mat');

z=50 ; 
cntr=1 ; 

%hold on 
%plot(20:90,20:90) ;

%Loop over repetitions

for d = 1:z
    d    
    %SVMR

    %For each subject
    for s=1:n_obs_trim    

       %Find the index in the first repetiton data corresponding to that subject
       sub_ind = reps_results_subj_pls(d,:)==subj_id(s)  ;     

       %Use that index to get the actual age for that subject
       actual =  reps_results_act_pls(d,sub_ind) ; 

       %Use that index to get the predicted age for that subject
       fit =  reps_results_fit_pls(d,sub_ind) ; 

       %Store those values in two arrays
       fit_mean_val_pls(s) = fit ; 
       act_val(s) = actual(1) ;  
    end
    
    %Store the results for this repetition in a matrix
    all_points(d,:) = fit_mean_val_pls  ; 
    
    %Calculate the Error
    svm_error = mean(abs(fit_mean_val_pls-act_val)) ;
    
    %Plots each point  
    %scatter(act_val,fit_mean_val_svm) ;       
    %xlabel('Actual')
    %ylabel('Prediction')
    %title(' SVM Regression All Repetitions ')    
    %rep_score(cntr) = svm_error  ; 

    cntr=cntr+1 ; 
    
end 
 
%hold off
 
 %Calculate mean and std across the repetitions
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
 title(' PLS Regression ')
 
 hold off


%  %Subjectwise error
%  
% error_subject = (mean_all-act_val) ;
%  
% compare = [ subj_id act_val' mean_all' error_subject'  ] 
% 
% save('subject_compare_svm.mat','compare') ; 
 
 