%% 用于提取图像的主程序
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

%% init global parameters

initExtractArgsFirst;
Args.mode = '1' ; % 提取指定的文件和文件夹的模式
Args.folderpath_EachImageResourcesBaseFolder = '.\candidate\resources';    % 基础资源文件（原图、真值图、标记图）的基本路径

Args.folderpath_outputBase = '.\data\ACMGMMSEMI\MSRA1K\extract'; % 提取文件的目标文件夹


%% extract
Args.folderpath_EachImageInitBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_kmean100';    % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\semisupervised';
Args = setExtractArgs(Args);
collectImagesForExtractByOtherIndicator_func(Args);

Args.folderpath_initDatasets = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle';    % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\unsupervised';
Args = setExtractArgs(Args);
collectImagesForExtractByOtherIndicator_func(Args);










