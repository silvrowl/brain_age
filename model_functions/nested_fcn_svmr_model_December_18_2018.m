%Script to predict age using nested crossvalidation of heirarchal PLS model 

function [final_yfit final_test final_subj ] = nested_fcn_svmr_model_December_18_2018(X,Y,subj_id,z)

    %Split into 10 equal sized groups
    indices_top = crossvalind('Kfold',Y,10);

    final_test = [] ; 
    final_yfit = [] ; 
    final_subj = [] ;

    for group = 1:10

        subj_group = subj_id(indices_top==group,:) ; 
        
        %Outer test set
        test_1 = X(indices_top==group,:) ; 
        test_y = Y(indices_top==group,:) ;     

        %Outer train set 
        train_1 = X(indices_top~=group,:) ; 
        train_y = Y(indices_top~=group,:) ;

        %Parameter tuning on each group (Comp_tot,Comp_1,Comp_2,Comp3)
        %Create Parameter Search Grid    
        n_train = size(train_y,1) ;               

        inner_mdl = fitrsvm(train_1,train_y,'OptimizeHyperparameters','auto',...
    'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
    'expected-improvement-plus')) ; 

        close all

        yfit_in = predict(inner_mdl,train_1) ; 
        error_inside = sqrt(mean((yfit_in-train_y).^2)) ;  
        
        par_1_bx_con = inner_mdl.ModelParameters.BoxConstraint ; 
        par_2_kr_scl = inner_mdl.ModelParameters.KernelScale ; 
        par_3_epsil = inner_mdl.ModelParameters.Epsilon ;
         
        %Compute fitted Y from test scores and Betas from model
        yfit_out = predict(inner_mdl,test_1) ; 

        %Compute RMSE for this partition
        error_outside = sqrt(mean((yfit_out-test_y).^2)) ;  

        %Keep track of results
        final_test = [ final_test test_y' ]  ; 
        final_yfit = [ final_yfit yfit_out' ] ; 
        final_subj = [ final_subj subj_group' ] ; 
        
        final_param(group,:) = [z group par_1_bx_con par_2_kr_scl par_3_epsil error_inside error_outside] ; 

    end

end
