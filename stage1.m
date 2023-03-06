function [EPFresult, probability_s1] = stage1( img,Tr,Te )

[no_rows, no_cols, no_bands] = size(img);

%%%% vectorization
img = ToVector(img);
img = img';
img = double(img);

%Training and testing samples
train_SL=matricetotwo(Tr);
train_samples = img(:,train_SL(1,:))';
train_labels= train_SL(2,:)';

test_SL=matricetotwo(Te);
test_samples = img(:,test_SL(1,:))';
test_labels = test_SL(2,:)';


%%%% Normalize the training set and original image
[train_samples,M,m] = scale_func(train_samples);
[img ] = scale_func(img',M,m);

%%%% Select the paramter for SVM with five-fold cross validation
[Ccv Gcv cv cv_t]=cross_validation_svm(train_labels,train_samples);

%%%% Training using a Gaussian RBF kernel
%%% give the parameters of the SVM (Thanks Pedram for providing the
%%% parameters of the SVM)
%parameter=sprintf('-c %f -g %f -m 500 -t 2 -q',Ccv,Gcv); 
parameter=sprintf('-s 0 -t 2 -c %f -g %f -m 500 -b 1',Ccv,Gcv);

%%% Train the SVM
model=svmtrain(train_labels,train_samples,parameter);

%%%% SVM Classification
%SVMresult = svmpredict(ones(no_rows*no_cols,1),img,model); 
[SVMresult, accuracy,prob]= svmpredict(ones(no_rows*no_cols,1),img,model,'-b 1');
prob=reshape(prob,[no_rows no_cols max(SVMresult(:))]);
probability_s1=prob;
%probability_s1=reshape(prob,[no_rows no_cols max(SVMresult(:))]);

%%%% Evaluation the performance of the SVM
%GroudTest = double(test_labels(:,1));
%SVMResultTest = SVMresult(test_SL(1,:),:);
%[SVMOA,SVMAA,SVMkappa,SVMCA]=confusion(GroudTest,SVMResultTest)
%%%% Display the result of SVM 
SVMresult = reshape(SVMresult,no_rows,no_cols);
%SVMmap = label2color(SVMresult,'india');
%figure,imshow(SVMmap);

%%%% EPF based spectral-spatial classification
tic
[ EPFresult,GDimg ] = EPF(3,1,img,SVMresult);
toc
%%% shows the computing time of EPF
EPFresult =reshape(EPFresult,[no_cols*no_rows 1]);
%EPFresulttest = EPFresult(test_SL(1,:),:);
%%%% Evaluation the performance of the EPF
%[OA,AA,kappa,CA]=confusion(GroudTest,EPFresulttest)
%EPFresult =reshape(EPFresult,[no_rows no_cols]);
%%%% Display the result of EPF 
%EPFmap=label2color(EPFresult,'india');
%figure,imshow(EPFmap);
%%%%%%%probability_s1= GDimg;
end

