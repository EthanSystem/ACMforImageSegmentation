% %% 用于计算评估值的主程序
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


Args.folderpath_resourcesBaseFolder='.\data\ACMGMMSEMI\MSRA1K\original resources';

% 其实 folderpath_initBaseFolder 在计算指标的时候不重要，随便设置一个就可以了。
Args.folderpath_initBaseFolder='.\data\ACMGMMSEMI\MSRA1K\init resources\circle';

%% 用于无监督
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\试验1 更改了g函数计算方式\new\su';
Args.mode = '3';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

%% 用于半监督
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\试验1 更改了g函数计算方式\new\semi';
Args.mode = '1';
Args = setEvaluationCalculate(Args);
evaluationCalculate_func(Args, Args.mode);

% Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\calculation\unsupervised';
% Args.mode = '3';
% Args = setEvaluationCalculate(Args);
% evaluationCalculate_func(Args, Args.mode);






%% end
text=['程序全部运行完毕。'];
sp.Speak(text);














