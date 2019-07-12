%Script to prediect age using nested crossvalidation of heirarchal PLS model 

function [final_yfit final_test final_subj ] = nested_fcn_pls_model_December_18_2018(X,Y,subj_id,z)

    X1 = X(:,[137:240] -2)  ;  %Thickness and Mean and Average diffusivity
    X2 = X(:,[3:17] -2) ;  %Behavior
    X3 = X(:,[18:136] -2)  ; % 17 Network Connectivity System Segregation

    %Split into 10 equal sized groups
    indices_top = crossvalind('Kfold',Y,10);

    final_test = [] ; 
    final_yfit = [] ; 
    final_subj = [] ;

    for group = 1:10

        subj_group = subj_id(indices_top==group,:) ; 
        
        %Outer test set
        test_1 = X1(indices_top==group,:) ; 
        test_2 = X2(indices_top==group,:) ;
        test_3 = X3(indices_top==group,:) ;
        test_y = Y(indices_top==group,:) ;     

        %Outer train set 
        train_1 = X1(indices_top~=group,:) ; 
        train_2 = X2(indices_top~=group,:) ;
        train_3 = X3(indices_top~=group,:) ;
        train_y = Y(indices_top~=group,:) ;

        %Parameter tuning on each group (Comp_tot,Comp_1,Comp_2,Comp3)
        %Create Parameter Search Grid    
        n_train = size(train_y,1) ;    

        for search=1:1000

            [ z group search ] 

            %Initialize random Parameters
            Comp_1 = randi([1,15]) ; 
            Comp_2 = randi([1,13]) ; 
            Comp_3 = randi([1,15]) ; 
            comp_max = Comp_1 + Comp_2 + Comp_3 ;         
            Comp_tot = randi([1,20]) ; 
            
            if Comp_tot>comp_max
                Comp_tot=comp_max ; 
            end

            %Break into test and train sets
            train_ind = 1:n_train ;         
            test_ind = randsample(n_train,8) ; 
            train_ind(test_ind) = [] ;         

            %Inner test set
            test_in_1 = train_1(test_ind,:) ; 
            test_in_2 = train_2(test_ind,:) ;
            test_in_3 = train_3(test_ind,:) ;
            test_in_y = train_y(test_ind,:) ;     

            %Inner train set 
            train_in_1 = train_1(train_ind,:) ; 
            train_in_2 = train_2(train_ind,:) ;
            train_in_3 = train_3(train_ind,:) ;
            train_in_y = train_y(train_ind,:) ;

            %Run PLS regression on each sub group of variables
            [XL1,YL1,XS1,YS1,BETA1,PCTVAR1,MSE1,stats1] = plsregress(train_in_1,train_in_y,Comp_1) ; 
            [XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] = plsregress(train_in_2,train_in_y,Comp_2) ; 
            [XL3,YL3,XS3,YS3,BETA3,PCTVAR3,MSE3,stats3] = plsregress(train_in_3,train_in_y,Comp_3) ; 

            %Combine Scores 
            X_Compile = [ XS1 XS2 XS3 ] ;    

            %Run PLS regression on scores
            [XLT,YLT,XST,YST,BETAT,PCTVART,MSET,statsT] = plsregress(X_Compile,train_in_y,Comp_tot) ;         

            %Load test data onto model loadings
            X_re_in_1 = (test_in_1*pinv(XL1')) ; 
            X_re_in_2 = (test_in_2*pinv(XL2')) ; 
            X_re_in_3 = (test_in_3*pinv(XL3')) ; 

            %Compile the test scores togethers
            X_re_in_comp = [ X_re_in_1 X_re_in_2 X_re_in_3 ] ; 

            %Compute fitted Y from test scores and Betas from model
            yfit_in = [ones(size( X_re_in_comp,1),1)  X_re_in_comp]*BETAT; 

            %Compute RMSE for this partition
            error_inside = sqrt(mean((yfit_in-test_in_y).^2)) ;  

            %Keep track of results
            tuning_data(search,:) = [ search Comp_1 Comp_2 Comp_3 Comp_tot error_inside ]  ;      

        end    

        %pause
        %Find best tuning parameters

    %     figure(1); boxplot(tuning_data(:,6),tuning_data(:,2))
    %     figure(2); boxplot(tuning_data(:,6),tuning_data(:,3))
    %     figure(3); boxplot(tuning_data(:,6),tuning_data(:,4))
    %     figure(4); boxplot(tuning_data(:,6),tuning_data(:,5))

        test1 = grpstats(tuning_data(:,6),tuning_data(:,2)) ; 
        test2 = grpstats(tuning_data(:,6),tuning_data(:,3)) ; 
        test3 = grpstats(tuning_data(:,6),tuning_data(:,4)) ; 
        test4 = grpstats(tuning_data(:,6),tuning_data(:,5)) ; 
        
        
        %Plot means 
        [m1,i1] = min(test1) ;
        [m2,i2] = min(test2) ;
        [m3,i3] = min(test3) ; 
        [m4,i4] = min(test4(1:end-3)) ;     

        clear tuning_data

        select = 1:30; 

        %Set Parameters
        Comp_1_sel = select(i1) ; 
        Comp_2_sel = select(i2) ; 
        Comp_3_sel = select(i3) ;  

        max_sel  = Comp_1_sel + Comp_2_sel + Comp_3_sel ; 

        if select(i4)>max_sel    
            Comp_tot_sel = max_sel ;      
        else
            Comp_tot_sel = select(i4) ;
        end

        %error_in = sorted(1,6) ; 

        %Apply tuned parameters to each test group
        [XL1,YL1,XS1,YS1,BETA1,PCTVAR1,MSE1,stats1] = plsregress(train_1,train_y,Comp_1_sel) ; 
        [XL2,YL2,XS2,YS2,BETA2,PCTVAR2,MSE2,stats2] = plsregress(train_2,train_y,Comp_2_sel) ; 
        [XL3,YL3,XS3,YS3,BETA3,PCTVAR3,MSE3,stats3] = plsregress(train_3,train_y,Comp_3_sel) ; 

        %Compile scores for each group
        X_Compile = [ XS1 XS2 XS3 ] ; 

        %Run PLS regression on scores
        [XLT,YLT,XST,YST,BETAT,PCTVART,MSET,statsT] = plsregress(X_Compile,train_y,Comp_tot_sel) ;   

        %Load test data onto model loadings
        X_re_1 = (test_1*pinv(XL1')) ; 
        X_re_2 = (test_2*pinv(XL2')) ; 
        X_re_3 = (test_3*pinv(XL3')) ; 

        %Compile the test scores togethers
        X_re_comp = [ X_re_1 X_re_2 X_re_3 ] ; 

        %Compute fitted Y from test scores and Betas from model
        Yfit = [ones(size( X_re_comp,1),1)  X_re_comp]*BETAT;

        clear X_re_1 X_re_2 X_re_3 X_re_comp 

        %Keep track of results
        final_test = [ final_test test_y' ]  ; 
        final_yfit = [ final_yfit Yfit' ] ; 
        final_subj = [ final_subj subj_group' ] ; 
        
        final_param(group,:) = [z group Comp_1_sel Comp_2_sel Comp_3_sel Comp_tot_sel] ; 

    end    
end
