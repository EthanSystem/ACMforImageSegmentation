%% 用于计算评估值的主程序
% 实验1,2,3一起评估。2018/03/01

%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
addpath( genpath( '.\functions' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\projects' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\tools' ) ); %添加当前路径下的所有文件夹以及子文件夹

%% segmentation

% 初始全局设置项
initEvaluationCalculateArgsFirst;

%% 用于无监督
Args.folderpath_resourcesBaseFolder = '.\data\resources\MSRA1K\original resources'; % 用于计算文件的结构体 EachImage 的基本路径
% 其实 folderpath_initBaseFolder 在计算指标的时候不重要，随便设置一个就可以了。
Args.folderpath_initBaseFolder ='.\data\resources\MSRA1K\init resources'; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\calculation\unsu'; % 用于计算文件的结构体 Results 的基本路径。
Args.mode = '3';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

%% 用于半监督
Args.folderpath_resourcesBaseFolder = '.\data\resources\MSRA1K\original resources'; % 用于计算文件的结构体 EachImage 的基本路径
% 其实 folderpath_initBaseFolder 在计算指标的时候不重要，随便设置一个就可以了。
Args.folderpath_initBaseFolder ='.\data\resources\MSRA1K\init resources'; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\calculation\su'; % 用于计算文件的结构体 Results 的基本路径。
Args.mode = '1';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);




%% end
text=['程序全部运行完毕。'];
% sp.Speak(text);














