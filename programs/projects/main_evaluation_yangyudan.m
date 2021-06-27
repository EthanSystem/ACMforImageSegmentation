%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


%% 预处理
clear all;
close all;
clc;
diary off;

addpath( genpath( '.\functions' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\projects' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\tools' ) ); %添加当前路径下的所有文件夹以及子文件夹

%% 初始全局设置项
setEvaluationCalculateArgsFirst;

%% 额外的全局设置项
% Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果是，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
% Args.foldername_EachImageBaseFolder = '.\data\resources\circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circle';

evaluationCalculate_func(Args)





































