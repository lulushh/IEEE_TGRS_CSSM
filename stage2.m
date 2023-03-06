function [result1, probability_s2 ] = stage2( img,Tr,Te)
[no_lines, no_rows, no_bands] = size(img);
%% feature extraction
fimg_fea = dealimg(img);

fimg2 = ToVector(fimg_fea);
fimg2 = fimg2';
fimg2=double(fimg2);
%% Training and testing samplesF
train_SL=matricetotwo(Tr);
train_samples = fimg2(:,train_SL(1,:))';
train_labels= train_SL(2,:)';

test_SL=matricetotwo(Te);
test_samples = fimg2(:,test_SL(1,:))';
test_labels = test_SL(2,:)';

%% Spectral classifier
% Normalizing Training and original img 
[train_samples,M,m] = scale_func(train_samples);
[fimg3 ] = scale_func(fimg2',M,m);
% Selecting the paramter for SVM
[Ccv Gcv cv cv_t]=cross_validation_svm(train_labels,train_samples);
% Training using a Gaussian RBF kernel
%give the parameters of the SVM 
parameter=sprintf('-s 0 -t 2 -c %f -g %f -m 500 -b 1',Ccv,Gcv); 
% parameter=sprintf('-c %f -g %f -m 500 -t 2 -q -b 1',Ccv,Gcv);
%%% Train the SVM
model=svmtrain(train_labels,train_samples,parameter);
[result1, accuracy,prob] = svmpredict(ones(no_lines*no_rows,1) ,fimg3,model,'-b 1');  
prob=reshape(prob,[no_lines no_rows max(result1(:))]);
%prob=reshape(prob,[no_lines no_rows 9]);
probability_s2=prob;

end

