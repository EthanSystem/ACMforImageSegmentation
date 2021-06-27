function [ output_args ] = evaluation_statistic( typeOfIndicator, Pros, EachImage, Results, index_experiment01, index_experiment02 )
%evaluation_statistic 评价结果统计
%   此处显示详细说明
switch typeOfIndicator
    case 'Jaccard'
        filenameStr = '_Jaccard_compareTwo' ;
        load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'jaccardDistance.mat'));
        jaccardDistance_1=jaccardDistance;
        name_evaluationData_1 = 'jaccardDistance_1';
        clear jaccardDistance;
        load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'jaccardDistance.mat'));
        jaccardDistance_2=jaccardDistance;
        clear jaccardDistance;
        name_evaluationData_2 = 'jaccardDistance_2';
        labelStr = 'Jaccard Distance';
        ceilValue = 1;
        isReverseAxes = 'yes';
        
    case 'ModifiedHausdorff'
        filenameStr = '_ModiHausdorff_compareTwo' ;
        load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
        modifiedHausdorffDistance_1=modifiedHausdorffDistance;
        name_evaluationData_1 = 'modifiedHausdorffDistance_1';
        clear modifiedHausdorffDistance;
        load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'modifiedHausdorffDistance.mat'));
        modifiedHausdorffDistance_2=modifiedHausdorffDistance;
        clear modifiedHausdorffDistance;
        name_evaluationData_2 = 'modifiedHausdorffDistance_2';
        labelStr = 'Modified Hausdorff Distance';
        ceilValue = max(max(modifiedHausdorffDistance_1),max(modifiedHausdorffDistance_2));
        isReverseAxes = 'yes';
        
    case 'F1'
        filenameStr = '_F1_compareTwo' ;
        load(fullfile(Results.experiments(index_experiment01).folderpath_evaluationData, 'F1.mat'));
        F1_1=F1;
        name_evaluationData_1 = 'F1_1';
        clear F1;
        load(fullfile(Results.experiments(index_experiment02).folderpath_evaluationData, 'F1.mat'));
        F1_2=F1;
        clear F1;
        name_evaluationData_2 = 'F1_2';
        labelStr = 'F1';
        ceilValue = 1;
        isReverseAxes = 'no';
        
end

%% 统计对比两种方法在各自指标下，图像数量的属性

eval(['data_1=' name_evaluationData_1 ';']);
eval(['data_2=' name_evaluationData_2 ';']);



if strcmp(isReverseAxes,'yes')==1
    indexes=1:1:Pros.num_image;
    data=[indexes' data_1 data_2];
    
    % 方法一处理的图像从好到坏排序
    images1_sort=sortrows(data,2);
    
    % 方法二处理的图像从好到坏排序
    images2_sort=sortrows(data,3);
    
    % 寻找方法一处理效果好的图像集合和图像数
    imagesGoodAt1(:,1) = find(data_1<=(1-Pros.ratioOfGood)*ceilValue);
    imagesGoodAt1(:,2) = data_1(imagesGoodAt1(:,1));
    imagesGoodAt1=sortrows(imagesGoodAt1,2);
    num_imagesGoodAt1 = size(imagesGoodAt1,1);
    
    % 寻找方法二处理效果好的图像集合和图像数
    imagesGoodAt2(:,1) = find(data_2<=(1-Pros.ratioOfGood)*ceilValue);
    imagesGoodAt2(:,2) = data_2(imagesGoodAt2(:,1));
    imagesGoodAt2=sortrows(imagesGoodAt2,2);
    num_imagesGoodAt2 = size(imagesGoodAt2,1);
    
    % 寻找方法一处理效果不好的图像集合和图像数
    imagesBadAt1(:,1) = find(data_1>=(1-Pros.ratioOfBad)*ceilValue);
    imagesBadAt1(:,2) = data_1(imagesBadAt1(:,1));
    imagesBadAt1=sortrows(imagesBadAt1,-2);
    num_imagesBadAt1 = size(imagesBadAt1,1);
    
    % 寻找方法二处理效果不好的图像集合和图像数
    imagesBadAt2 = find(data_2>=(1-Pros.ratioOfBad)*ceilValue);
    imagesBadAt2(:,2) = data_2(imagesBadAt2(:,1));
    imagesBadAt2=sortrows(imagesBadAt2,-2);
    num_imagesBadAt2 = size(imagesBadAt2,1);
    
    % 寻找两种方法效果都好的图像集合和图像数
    imagesGoodAt1and2(:,1) = find(data_1<=(1-Pros.ratioOfGood)*ceilValue & data_2<=(1-Pros.ratioOfGood)*ceilValue);
    imagesGoodAt1and2(:,2) = data_1(imagesGoodAt1and2(:,1));
    imagesGoodAt1and2(:,3) = data_2(imagesGoodAt1and2(:,1));
    imagesGoodAt1and2_sortBy2 = sortrows(imagesGoodAt1and2,2);
    imagesGoodAt1and2_sortBy3 = sortrows(imagesGoodAt1and2,3);
    num_imagesGoodAt1and2 = size(imagesGoodAt1and2,1);
    
    % 寻找两种方法效果都好，且方法一比方法二处理效果好的图像集合和图像数
    images1better2AtBothGood(:,1) = find(data_1<=(1-Pros.ratioOfGood)*ceilValue & data_2<=(1-Pros.ratioOfGood)*ceilValue & data_2-data_1>=Pros.ratioOfBetterAtBothGood*ceilValue);
    images1better2AtBothGood(:,2) = data_1(images1better2AtBothGood(:,1));
    images1better2AtBothGood(:,3) = data_2(images1better2AtBothGood(:,1));
    images1better2AtBothGood(:,4) = abs(images1better2AtBothGood(:,2) - images1better2AtBothGood(:,3));
    images1better2AtBothGood_sortBy4 = sortrows(images1better2AtBothGood,4);
    num_images1better2AtBothGood = size(images1better2AtBothGood,1);
    
    % 寻找两种方法效果都好，且方法二比方法一处理效果好的图像集合和图像数
    images2better1AtBothGood(:,1) = find(data_2<=(1-Pros.ratioOfGood)*ceilValue & data_1<=(1-Pros.ratioOfGood)*ceilValue & data_1-data_2>=Pros.ratioOfBetterAtBothGood*ceilValue);
    images2better1AtBothGood(:,2) = data_1(images2better1AtBothGood(:,1));
    images2better1AtBothGood(:,3) = data_2(images2better1AtBothGood(:,1));
    images2better1AtBothGood(:,4) = abs(images2better1AtBothGood(:,2) - images2better1AtBothGood(:,3));
    images2better1AtBothGood_sortBy4 = sortrows(images2better1AtBothGood,4);
    num_images2better1AtBothGood = size(images2better1AtBothGood,1);
    
    % 寻找方法一效果好、且方法二效果不差，且方法一比方法二好一些的图像集合和图像数
    images1better2And1GoodAnd2NotBad(:,1) = find(data_1<=(1-Pros.ratioOfGood)*ceilValue & data_2<=(1-Pros.ratioOfBad)*ceilValue & data_2-data_1>=Pros.ratioOfBetter*ceilValue);
    images1better2And1GoodAnd2NotBad(:,2) = data_1(images1better2And1GoodAnd2NotBad(:,1));
    images1better2And1GoodAnd2NotBad(:,3) = data_2(images1better2And1GoodAnd2NotBad(:,1));
    images1better2And1GoodAnd2NotBad(:,4) = abs(images1better2And1GoodAnd2NotBad(:,2) - images1better2And1GoodAnd2NotBad(:,3));
    images1better2And1GoodAnd2NotBad_sortBy4 = sortrows(images1better2And1GoodAnd2NotBad,4);
    num_images1better2And1GoodAnd2NotBad = size(images1better2And1GoodAnd2NotBad,1);
    
    % 寻找方法一效果不差、且方法二效果不差，且方法一比方法二好一些的图像集合和图像数
    images1better2And1NotBadAnd2NotBad(:,1) = find(data_1<=(1-Pros.ratioOfBad)*ceilValue & data_2<=(1-Pros.ratioOfBad)*ceilValue & data_2-data_1>=Pros.ratioOfBetter*ceilValue);
    images1better2And1NotBadAnd2NotBad(:,2) = data_1(images1better2And1NotBadAnd2NotBad(:,1));
    images1better2And1NotBadAnd2NotBad(:,3) = data_2(images1better2And1NotBadAnd2NotBad(:,1));
    images1better2And1NotBadAnd2NotBad(:,4) = abs(images1better2And1NotBadAnd2NotBad(:,2) - images1better2And1NotBadAnd2NotBad(:,3));
    images1better2And1NotBadAnd2NotBad_sortBy4 = sortrows(images1better2And1NotBadAnd2NotBad,4);
    num_images1better2And1NotBadAnd2NotBad = size(images1better2And1NotBadAnd2NotBad,1);
    
    % 寻找方法二效果好、且方法一效果不差，且方法二比方法一好一些的图像集合和图像数
    images2better1And2GoodAnd1NotBad(:,1) = find(data_2<=(1-Pros.ratioOfGood)*ceilValue & data_1<=(1-Pros.ratioOfBad)*ceilValue & data_1-data_2>=Pros.ratioOfBetter*ceilValue);
    images2better1And2GoodAnd1NotBad(:,2) = data_1(images2better1And2GoodAnd1NotBad(:,1));
    images2better1And2GoodAnd1NotBad(:,3) = data_2(images2better1And2GoodAnd1NotBad(:,1));
    images2better1And2GoodAnd1NotBad(:,4) = abs(images2better1And2GoodAnd1NotBad(:,2) - images2better1And2GoodAnd1NotBad(:,3));
    images2better1And2GoodAnd1NotBad_sortBy4 = sortrows(images2better1And2GoodAnd1NotBad,4);
    num_images2better1And2GoodAnd1NotBad = size(images2better1And2GoodAnd1NotBad,1);
    
    % 寻找方法二效果不差、且方法一效果不差，且方法二比方法一好一些的图像集合和图像数
    images2better1And2NotBadAnd1NotBad(:,1) = find(data_2<=(1-Pros.ratioOfBad)*ceilValue & data_1<=(1-Pros.ratioOfBad)*ceilValue & data_1-data_2>=Pros.ratioOfBetter*ceilValue);
    images2better1And2NotBadAnd1NotBad(:,2) = data_1(images2better1And2NotBadAnd1NotBad(:,1));
    images2better1And2NotBadAnd1NotBad(:,3) = data_2(images2better1And2NotBadAnd1NotBad(:,1));
    images2better1And2NotBadAnd1NotBad(:,4) = abs(images2better1And2NotBadAnd1NotBad(:,2) - images2better1And2NotBadAnd1NotBad(:,3));
    images2better1And2NotBadAnd1NotBad_sortBy4 = sortrows(images2better1And2NotBadAnd1NotBad,4);
    num_images2better1And2NotBadAnd1NotBad = size(images2better1And2NotBadAnd1NotBad,1);
    
	
end

if strcmp(isReverseAxes,'no')==1
    indexes=1:1:Pros.num_image;
    data=[indexes' data_1 data_2];
    
    % 方法一处理的图像从好到坏排序
    images1_sort=sortrows(data,-2);
    
    % 方法二处理的图像从好到坏排序
    images2_sort=sortrows(data,-3);
    
    % 寻找方法一处理效果好的图像集合和图像数
    imagesGoodAt1(:,1) = find(data_1>=Pros.ratioOfGood*ceilValue);
    imagesGoodAt1(:,2) = data_1(imagesGoodAt1(:,1));
    imagesGoodAt1=sortrows(imagesGoodAt1,-2);
    num_imagesGoodAt1 = size(imagesGoodAt1,1);
    
    % 寻找方法二处理效果好的图像集合和图像数
    imagesGoodAt2(:,1) = find(data_2>=Pros.ratioOfGood*ceilValue);
    imagesGoodAt2(:,2) = data_2(imagesGoodAt2(:,1));
    imagesGoodAt2=sortrows(imagesGoodAt2,-2);
    num_imagesGoodAt2 = size(imagesGoodAt2,1);
    
    % 寻找方法一处理效果不好的图像集合和图像数
    imagesBadAt1(:,1) = find(data_1<=Pros.ratioOfBad*ceilValue);
    imagesBadAt1(:,2) = data_1(imagesBadAt1(:,1));
    imagesBadAt1=sortrows(imagesBadAt1,2);
    num_imagesBadAt1 = size(imagesBadAt1,1);
    
    % 寻找方法二处理效果不好的图像集合和图像数
    imagesBadAt2 = find(data_2<=Pros.ratioOfBad*ceilValue);
    imagesBadAt2(:,2) = data_2(imagesBadAt2(:,1));
    imagesBadAt2=sortrows(imagesBadAt2,2);
    num_imagesBadAt2 = size(imagesBadAt2,1);
    
    % 寻找两种方法效果都好的图像集合和图像数
    imagesGoodAt1and2(:,1) = find(data_1>=Pros.ratioOfGood*ceilValue & data_2>=Pros.ratioOfGood*ceilValue);
    imagesGoodAt1and2(:,2) = data_1(imagesGoodAt1and2(:,1));
    imagesGoodAt1and2(:,3) = data_2(imagesGoodAt1and2(:,1));
    imagesGoodAt1and2_sortBy2 = sortrows(imagesGoodAt1and2,-2);
    imagesGoodAt1and2_sortBy3 = sortrows(imagesGoodAt1and2,-3);
    num_imagesGoodAt1and2 = size(imagesGoodAt1and2,1);
    
    % 寻找两种方法效果都好，且方法一比方法二处理效果好的图像集合和图像数
    images1better2AtBothGood(:,1) = find(data_1>=Pros.ratioOfGood*ceilValue & data_2>=Pros.ratioOfGood*ceilValue & data_1-data_2>=Pros.ratioOfBetterAtBothGood*ceilValue);
    images1better2AtBothGood(:,2) = data_1(images1better2AtBothGood(:,1));
    images1better2AtBothGood(:,3) = data_2(images1better2AtBothGood(:,1));
    images1better2AtBothGood(:,4) = images1better2AtBothGood(:,2) - images1better2AtBothGood(:,3);
    images1better2AtBothGood_sortBy4 = sortrows(images1better2AtBothGood,-4);
    num_images1better2AtBothGood = size(images1better2AtBothGood,1);
    
    % 寻找两种方法效果都好，且方法二比方法一处理效果好的图像集合和图像数
    images2better1AtBothGood(:,1) = find(data_2>=Pros.ratioOfGood*ceilValue & data_1>=Pros.ratioOfGood*ceilValue & data_2-data_1>=Pros.ratioOfBetterAtBothGood*ceilValue);
    images2better1AtBothGood(:,2) = data_1(images2better1AtBothGood(:,1));
    images2better1AtBothGood(:,3) = data_2(images2better1AtBothGood(:,1));
    images2better1AtBothGood(:,4) = images2better1AtBothGood(:,2) - images2better1AtBothGood(:,3);
    images2better1AtBothGood_sortBy4 = sortrows(images2better1AtBothGood,-4);
    num_images2better1AtBothGood = size(images2better1AtBothGood,1);
    
    % 寻找方法一效果好、且方法二效果不差，且方法一比方法二好一些的图像集合和图像数
    images1better2And1GoodAnd2NotBad(:,1) = find(data_1>=Pros.ratioOfGood*ceilValue & data_2>=Pros.ratioOfBad*ceilValue & data_1-data_2>=Pros.ratioOfBetter*ceilValue);
    images1better2And1GoodAnd2NotBad(:,2) = data_1(images1better2And1GoodAnd2NotBad(:,1));
    images1better2And1GoodAnd2NotBad(:,3) = data_2(images1better2And1GoodAnd2NotBad(:,1));
    images1better2And1GoodAnd2NotBad(:,4) = images1better2And1GoodAnd2NotBad(:,2) - images1better2And1GoodAnd2NotBad(:,3);
    images1better2And1GoodAnd2NotBad_sortBy4 = sortrows(images1better2And1GoodAnd2NotBad,-4);
    num_images1better2And1GoodAnd2NotBad = size(images1better2And1GoodAnd2NotBad,1);
    
    % 寻找方法一效果不差、且方法二效果不差，且方法一比方法二好一些的图像集合和图像数
    images1better2And1NotBadAnd2NotBad(:,1) = find(data_1>=Pros.ratioOfBad*ceilValue & data_2>=Pros.ratioOfBad*ceilValue & data_1-data_2>=Pros.ratioOfBetter*ceilValue);
    images1better2And1NotBadAnd2NotBad(:,2) = data_1(images1better2And1NotBadAnd2NotBad(:,1));
    images1better2And1NotBadAnd2NotBad(:,3) = data_2(images1better2And1NotBadAnd2NotBad(:,1));
    images1better2And1NotBadAnd2NotBad(:,4) = images1better2And1NotBadAnd2NotBad(:,2) - images1better2And1NotBadAnd2NotBad(:,3);
    images1better2And1NotBadAnd2NotBad_sortBy4 = sortrows(images1better2And1NotBadAnd2NotBad,-4);
    num_images1better2And1NotBadAnd2NotBad = size(images1better2And1NotBadAnd2NotBad,1);
    
    % 寻找方法二效果好、且方法一效果不差，且方法二比方法一好一些的图像集合和图像数
    images2better1And2GoodAnd1NotBad(:,1) = find(data_2>=Pros.ratioOfGood*ceilValue & data_1>=Pros.ratioOfBad*ceilValue & data_2-data_1>=Pros.ratioOfBetter*ceilValue);
    images2better1And2GoodAnd1NotBad(:,2) = data_1(images2better1And2GoodAnd1NotBad(:,1));
    images2better1And2GoodAnd1NotBad(:,3) = data_2(images2better1And2GoodAnd1NotBad(:,1));
    images2better1And2GoodAnd1NotBad(:,4) = images2better1And2GoodAnd1NotBad(:,2) - images2better1And2GoodAnd1NotBad(:,3);
    images2better1And2GoodAnd1NotBad_sortBy4 = sortrows(images2better1And2GoodAnd1NotBad,-4);
    num_images2better1And2GoodAnd1NotBad = size(images2better1And2GoodAnd1NotBad,1);
    
    % 寻找方法二效果不差、且方法一效果不差，且方法二比方法一好一些的图像集合和图像数
    images2better1And2NotBadAnd1NotBad(:,1) = find(data_2>=Pros.ratioOfBad*ceilValue & data_1>=Pros.ratioOfBad*ceilValue & data_2-data_1>=Pros.ratioOfBetter*ceilValue);
    images2better1And2NotBadAnd1NotBad(:,2) = data_1(images2better1And2NotBadAnd1NotBad(:,1));
    images2better1And2NotBadAnd1NotBad(:,3) = data_2(images2better1And2NotBadAnd1NotBad(:,1));
    images2better1And2NotBadAnd1NotBad(:,4) = images2better1And2NotBadAnd1NotBad(:,2) - images2better1And2NotBadAnd1NotBad(:,3);
    images2better1And2NotBadAnd1NotBad_sortBy4 = sortrows(images2better1And2NotBadAnd1NotBad,-4);
    num_images2better1And2NotBadAnd1NotBad = size(images2better1And2NotBadAnd1NotBad,1);
    
end



%% visualization 可视化符合条件的二值图像
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , imagesGoodAt1and2_sortBy2 ,'imagesGoodAt1and2_sortBy2');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , imagesGoodAt1and2_sortBy3 ,'imagesGoodAt1and2_sortBy3');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2AtBothGood_sortBy4, 'images1better2AtBothGood_sortBy4');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1AtBothGood_sortBy4, 'images2better1AtBothGood_sortBy4');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2And1GoodAnd2NotBad_sortBy4, 'images1better2And1GoodAnd2NotBad_sortBy4');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1And2GoodAnd1NotBad_sortBy4, 'images2better1And2GoodAnd1NotBad_sortBy4');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2And1NotBadAnd2NotBad_sortBy4, 'images1better2And1NotBadAnd2NotBad_sortBy4');
% visualizeNeedBwImage( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1And2NotBadAnd1NotBad_sortBy4, 'images2better1And2NotBadAnd1NotBad_sortBy4');

%% visualization 可视化符合条件的二值图像（用于论文）
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , imagesGoodAt1and2_sortBy2 ,'imagesGoodAt1and2_sortBy2');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , imagesGoodAt1and2_sortBy3 ,'imagesGoodAt1and2_sortBy3');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2AtBothGood_sortBy4, 'images1better2AtBothGood_sortBy4');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1AtBothGood_sortBy4, 'images2better1AtBothGood_sortBy4');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2And1GoodAnd2NotBad_sortBy4, 'images1better2And1GoodAnd2NotBad_sortBy4');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1And2GoodAnd1NotBad_sortBy4, 'images2better1And2GoodAnd1NotBad_sortBy4');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images1better2And1NotBadAnd2NotBad_sortBy4, 'images1better2And1NotBadAnd2NotBad_sortBy4');
% visualizeNeedBwImageForPaper( Pros, EachImage, Results, Pros.isVisual, labelStr, index_experiment01, index_experiment02 , images2better1And2NotBadAnd1NotBad_sortBy4, 'images2better1And2NotBadAnd1NotBad_sortBy4');

%% collection 收集符合条件的二值图像到指定的文件夹
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,imagesGoodAt1and2_sortBy2, typeOfIndicator, 'imagesGoodAt1and2_sortBy2' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,imagesGoodAt1and2_sortBy3, typeOfIndicator, 'imagesGoodAt1and2_sortBy3' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images1better2AtBothGood_sortBy4, typeOfIndicator, 'images1better2AtBothGood_sortBy4' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images2better1AtBothGood_sortBy4, typeOfIndicator, 'images2better1AtBothGood_sortBy4' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images1better2And1GoodAnd2NotBad_sortBy4, typeOfIndicator, 'images1better2And1GoodAnd2NotBad_sortBy4' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images2better1And2GoodAnd1NotBad_sortBy4, typeOfIndicator, 'images2better1And2GoodAnd1NotBad_sortBy4' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images1better2And1NotBadAnd2NotBad_sortBy4, typeOfIndicator, 'images1better2And1NotBadAnd2NotBad_sortBy4' );
collectNeedBwImage(Pros, EachImage, Results, index_experiment01, index_experiment02 ,images2better1And2NotBadAnd1NotBad_sortBy4, typeOfIndicator, 'images2better1And2NotBadAnd1NotBad_sortBy4' );

%% save
filename_images1_sort = ['images1_sort' filenameStr '.mat'];
filepath_images1_sort = fullfile(Pros.folderpath_experiment, filename_images1_sort);
save(filepath_images1_sort,'images1_sort');

filename_images2_sort = ['images2_sort' filenameStr '.mat'];
filepath_images2_sort = fullfile(Pros.folderpath_experiment, filename_images2_sort);
save(filepath_images2_sort,'images2_sort');

filename_imagesGoodAt1 = ['imagesGoodAt1' filenameStr '.mat'];
filepath_imagesGoodAt1 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt1);
save(filepath_imagesGoodAt1,'imagesGoodAt1');

filename_imagesGoodAt2 = ['imagesGoodAt2' filenameStr '.mat'];
filepath_imagesGoodAt2 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt2);
save(filepath_imagesGoodAt2,'imagesGoodAt2');

filename_imagesBadAt1 = ['imagesBadAt1' filenameStr '.mat'];
filepath_imagesBadAt1 = fullfile(Pros.folderpath_experiment, filename_imagesBadAt1);
save(filepath_imagesBadAt1,'imagesBadAt1');

filename_imagesBadAt2 = ['imagesBadAt2' filenameStr '.mat'];
filepath_imagesBadAt2 = fullfile(Pros.folderpath_experiment, filename_imagesBadAt2);
save(filepath_imagesBadAt2,'imagesBadAt2');

filename_imagesGoodAt1and2_sortBy2 = ['imagesGoodAt1and2_sortBy2' filenameStr '.mat'];
filepath_imagesGoodAt1and2_sortBy2 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt1and2_sortBy2);
save(filepath_imagesGoodAt1and2_sortBy2,'imagesGoodAt1and2_sortBy2');

filename_imagesGoodAt1and2_sortBy3 = ['imagesGoodAt1and2_sortBy3' filenameStr '.mat'];
filepath_imagesGoodAt1and2_sortBy3 = fullfile(Pros.folderpath_experiment, filename_imagesGoodAt1and2_sortBy3);
save(filepath_imagesGoodAt1and2_sortBy3,'imagesGoodAt1and2_sortBy3');

filename_images1better2AtBothGood_sortBy4 = ['images1better2AtBothGood_sortBy4' filenameStr '.mat'];
filepath_images1better2AtBothGood_sortBy4 = fullfile(Pros.folderpath_experiment, filename_images1better2AtBothGood_sortBy4);
save(filepath_images1better2AtBothGood_sortBy4,'images1better2AtBothGood_sortBy4');

filename_images2better1AtBothGood_sortBy4 = ['images2better1AtBothGood_sortBy4' filenameStr '.mat'];
filepath_images2better1AtBothGood_sortBy4 = fullfile(Pros.folderpath_experiment, filename_images2better1AtBothGood_sortBy4);
save(filepath_images2better1AtBothGood_sortBy4,'images2better1AtBothGood_sortBy4');

filename_images1better2And1GoodAnd2NotBad_sortBy4 = ['images1better2And1GoodAnd2NotBad_sortBy4' filenameStr '.mat'];
filepath_images1better2And1GoodAnd2NotBad_sortBy4 = fullfile(Pros.folderpath_experiment, filename_images1better2And1GoodAnd2NotBad_sortBy4);
save(filepath_images1better2And1GoodAnd2NotBad_sortBy4,'images1better2And1GoodAnd2NotBad_sortBy4');

filename_images2better1And2GoodAnd1NotBad_sortBy4 = ['images2better1And2GoodAnd1NotBad_sortBy4' filenameStr '.mat'];
filepath_images2better1And2GoodAnd1NotBad_sortBy4 = fullfile(Pros.folderpath_experiment, filename_images2better1And2GoodAnd1NotBad_sortBy4);
save(filepath_images2better1And2GoodAnd1NotBad_sortBy4,'images2better1And2GoodAnd1NotBad_sortBy4');



%% disp number of images
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment01).name ' 处理效果好的图像数 = ' num2str(num_imagesGoodAt1)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment02).name ' 处理效果好的图像数 = ' num2str(num_imagesGoodAt2)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment01).name ' 处理效果不好的图像数 = ' num2str(num_imagesBadAt1)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment02).name ' 处理效果不好的图像数 = ' num2str(num_imagesBadAt2)])
disp(['评价指标 ' typeOfIndicator ' 下，两种方法处理效果都好的图像数 = ' num2str(num_imagesGoodAt1and2)])
disp(['评价指标 ' typeOfIndicator ' 下，两种方法处理效果都好，且方法 ' Results.experiments(Pros.experiment01).name ' 比方法 ' Results.experiments(Pros.experiment02).name ' 处理效果好的图像数 = ' num2str(num_images1better2AtBothGood)])
disp(['评价指标 ' typeOfIndicator ' 下，两种方法处理效果都好，且方法 ' Results.experiments(Pros.experiment02).name ' 比方法 ' Results.experiments(Pros.experiment01).name ' 处理效果好的图像数 = ' num2str(num_images2better1AtBothGood)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment01).name ' 效果好、且方法 ' Results.experiments(Pros.experiment02).name ' 效果不差，且方法 ' Results.experiments(Pros.experiment01).name ' 比方法 ' Results.experiments(Pros.experiment02).name ' 好的图像数 = ' num2str(num_images1better2And1GoodAnd2NotBad)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment02).name ' 效果好、且方法 ' Results.experiments(Pros.experiment01).name ' 效果不差，且方法 ' Results.experiments(Pros.experiment02).name ' 比方法 ' Results.experiments(Pros.experiment01).name ' 好的图像数 = ' num2str(num_images2better1And2GoodAnd1NotBad)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment01).name ' 效果不差、且方法 ' Results.experiments(Pros.experiment02).name ' 效果不差，且方法 ' Results.experiments(Pros.experiment01).name ' 比方法 ' Results.experiments(Pros.experiment02).name ' 好的图像数 = ' num2str(num_images1better2And1GoodAnd2NotBad)])
disp(['评价指标 ' typeOfIndicator ' 下，方法 ' Results.experiments(Pros.experiment02).name ' 效果不差、且方法 ' Results.experiments(Pros.experiment01).name ' 效果不差，且方法 ' Results.experiments(Pros.experiment02).name ' 比方法 ' Results.experiments(Pros.experiment01).name ' 好的图像数 = ' num2str(num_images2better1And2GoodAnd1NotBad)])








end

