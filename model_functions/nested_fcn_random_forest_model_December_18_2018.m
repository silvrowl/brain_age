%Script to prediect age using nested crossvalidation of heirarchal PLS model 

function [final_yfit final_test final_subj ] = nested_fcn_random_forest_model_December_18_2018(X,Y,subj_id,z)

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

        grd_cnt=1; 
        
        for inner_reps = 1:5        
            for g_1=1:8      
                for g_2=1:10                    

                    Comp1_list = [3 4 5 7 10 20 50 100] ; 
                    Comp2_list = 10:10:100 ; 

                    %Initialize random Parameters
                    Comp_1 = Comp1_list(g_1); %Leaf
                    Comp_2 = Comp2_list(g_2) ; %Number of Trees

                    %Break into test and train sets
                    train_ind = 1:n_train ;         
                    test_ind = randsample(n_train,6) ; 
                    train_ind(test_ind) = [] ;         

                    %Inner test set
                    test_in_1 = train_1(test_ind,:) ; 
                    test_in_y = train_y(test_ind,:) ;     

                    %Inner train set 
                    train_in_1 = train_1(train_ind,:) ; 
                    train_in_y = train_y(train_ind,:) ;

                    %Run PLS regression on each sub group of variables
                    mdl_in = TreeBagger(Comp_2,train_in_1,train_in_y,'MinLeafSize',Comp_1,'NumPredictorsToSample','all','Method','regression') ; 

                    %Predict model             
                    yfit_in = predict(mdl_in,test_in_1) ;

                    %Compute RMSE for this partition
                    error_inside = sqrt(mean((yfit_in-test_in_y).^2)) ;  

                    %Keep track of results
                    tuning_data(grd_cnt,:) = [ g_1 g_2 Comp_1 Comp_2 error_inside ]  ;  

                    [ z group inner_reps g_1 g_2 error_inside ] 
                    
                    grd_cnt = grd_cnt+1 ; 

                end
            end        
        end

        %Find best tuning parameters
        test1 = grpstats(tuning_data(:,5),tuning_data(:,3)) ; 
        test2 = grpstats(tuning_data(:,5),tuning_data(:,4)) ;         
        
        %Plot means 
        [m1,i1] = min(test1) ;
        [m2,i2] = min(test2) ;   

        clear tuning_data

        %Set Parameters
        Comp1_sel = Comp1_list(i1) ; 
        Comp2_sel = Comp2_list(i2) ; 

        %pause
        
        mdl_out = TreeBagger(Comp2_sel,train_1,train_y,'MinLeafSize',Comp1_sel,'NumPredictorsToSample','all','Method','regression') ; 
        yfit_out = predict(mdl_out,test_1) ;        

        %Keep track of results
        final_test = [ final_test test_y' ]  ; 
        final_yfit = [ final_yfit yfit_out' ] ; 
        final_subj = [ final_subj subj_group' ] ; 
        
        final_param(group,:) = [z group Comp1_sel Comp2_sel] ; 

    end

end



