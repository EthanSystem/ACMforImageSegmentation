%% 用于分割的主程序
% 		a. 对于 ACMGMM 方法类，在：
% 		evolution_ACMandSemisupervised_Eacm
% 		的方法的代码中，
% 		分别采用了不同 Eacm能量项的权重nu{ 1, 10, 100, 1000} 组合 长度项权重beta{0.0 ,  0.5 , 2.0 , 10.0} 组合 面积项权重gamma{0.0 , 0.5 , 2.0 , 10.0} 组合 步长值timestep{0.1 , 0.3 , 1.0 , 5.0} 一共 256 个实验组。探究各个参数对于分割结果的影响。



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
initSegmentationArgsFirst;

% 额外的全局设置项
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations';



%% semi-supervised segmentation


% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_1'; % 不推荐
% folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1'; % 不推荐
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1'; % 不推荐
% folderpath_EachImageInitBaseFolder_1{7} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{8} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{9} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2'; % 推荐

Args.markType='scribble';

% Args.timestep=10;  % time step, default = 0.10



%% ACMGMM_semisupervised_Eacm 在 不同初始化条件下、不同 Eacm 的权重下、不同步长值、长度权重、面积权重
Args.evolutionMethod='semiACMGMM_Eacm';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
for method=folderpath_EachImageInitBaseFolder_1
    if isempty(method{1})
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=method{1};
    for nu=[1 100]
        Args.nu = nu;
        for timestep=[0.01 0.03 0.10 0.25]
            Args.timestep=timestep;
            for beta=[0.00 0.01 0.10 0.25]
                Args.beta=beta;
                for gamma=[0.00 0.01 0.03 0.10 0.30]
                    Args.gamma=gamma;
                    Args.foldername_experiment =['ACMGMMsemi' '_timestep' num2str(Args.timestep) '_gamma' num2str(Args.gamma) '_beta' num2str(Args.beta) '_nu' num2str(Args.nu) '_' datestr(now,'ddHHMMSS')];
                    Args = setSegmentationMethod(Args, Args.evolutionMethod);
                    segmentation_func(Args);
                end
            end
        end
    end
end






%% end
text=['程序全部运行完毕。'];
sp.Speak(text);





