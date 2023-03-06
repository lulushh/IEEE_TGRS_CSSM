clc;
clear;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of paper "A Complementary Spectral-Spatial Method for Hyperspectral Image Classification"
% 
% Lulu Shi
% National University of Defense Technology
% 08 June, 2022
%
% Copyright 2022
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('SVM')
addpath('EPF')
addpath('SDSE')
addpath('drtoolbox')
addpath('KPCA')


%% Prepare image
load PaviaU
load PaviaU_gt

ori_img = double(paviaU);
labels = double(paviaU_gt);

% Normalize
g = Normalization(ori_img);
g1 = average_fusion(g,50);
[rows,cols,bands] = size(g);

% Input class number
no_classes = 9;

% Enter the number of training samples for each class
num_class = [10, 10, 10, 10, 10, 10, 10, 10, 10];%paviau
train_number = num_class;
[train_SL,test_SL,test_number]= GenerateSample(labels,train_number,no_classes);

% Generate training and test samples
Tr=zeros(rows, cols);
Tr(train_SL(1,:))=train_SL(2,:);
Te=zeros(rows, cols);
Te(test_SL(1,:))=test_SL(2,:);

% setup
opts.print   = true;
opts.method  = 'l2';
% setup mu
mu           = 12;


%% Main routine
tic
%% post-processing stage
[EPFresult,probability_s1] = stage1( g1,Tr,Te );
%% pre-processing stage
out = deconvtv(g1, 1, mu, opts);% img is the result after ACTVSP processing
img = out.f;
[result1,probability_s2] = stage2( img,Tr,Te );
toc
%% Decision fusion
t=0.7;% a weighted parameter
Fuse_pro=t.*probability_s2+(1-t).*probability_s1;

[Class_pro,Fuse_Result]=max(Fuse_pro,[],3);
Result=reshape(Fuse_Result,[rows*cols 1]);

GroudTest = double(test_SL(2,:)');
ResultTest = Result(test_SL(1,:),:);
%% Evaluation Index
[SVM_OA,SVM_AA,SVM_Kappa,SVM_CA]=confusion(GroudTest,ResultTest);
Result = reshape(Result,rows,cols);
%% Visualization
VClassMap=label2colord(Result,'uni');
figure,imshow(VClassMap);
labelMap = label2colord(labels,'uni');
figure,imshow(labelMap);

disp('%%%%%%%%%%%%%%%%%%% Classification Results of Our Method %%%%%%%%%%%%%%%%')
disp(['OA',' = ',num2str(SVM_OA),' ||  ','AA',' = ',num2str(SVM_AA),'  ||  ','Kappa',' = ',num2str(SVM_Kappa)])

