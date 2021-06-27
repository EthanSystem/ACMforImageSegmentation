%% 用于分割的主程序
% 实验2 半监督ACMGMM的实验系列


%% 注意事项：
% 手动把文件夹“ACM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


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


%% 路径设置项
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K\original resources';
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations\test analysis' ;

%% semi-supervised segmentation
% folderpath_EachImageInitBaseFolder_1{1} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\resources\MSRA1K\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{5} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\resources\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2';

Args.markType='scribble';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 1000  ;		% 外循环次数，default = 1000

%% ACM_semisupervised
% probability term
Args.timestep=0.10;  % time step, default = 0.10
Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.

% 以下不需要改
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。

% 以下不能改
Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。

%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%


%% ACMGMM_semisupervised  在 不同初始化条件下、不同停机条件下
Args.evolutionMethod='semiACMGMM';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder_1
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.00100 0.00030 0.00010]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMMsemi' '_init' num2str(i) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end



%% ACMGMM_semisupervised_Eacm 在 不同初始化条件下、不同停机条件下
% Args.evolutionMethod='semiACM_HuangTan';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['ACMGMMsemiEacm' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% ACMGMM_semisupervised_Eacm 在不同初始化条件下、不同停机条件下、 Eacm 的权重下
% Args.evolutionMethod='semiACMGMM_Eacm';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         for j=[1,10,100,1000]
%             Args.weight_Eacm = j;
%             Args.foldername_experiment =['ACMGMMsemiEacm' '_nu' num2str(Args.weight_Eacm) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%             segmentation_func(Args);
%         end
%     end
% end
%



%% ACMGMM_semisupervised_Eacm 在 不同初始化条件下、不同 Eacm 的权重下、不同步长值、长度权重、面积权重
% Args.evolutionMethod='semiACMGMM_Eacm';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for method=folderpath_EachImageInitBaseFolder_1
%     if isempty(method{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=method{1};
%     for nu=[1,10,100,1000]
%         Args.nu = nu;
%         for timestep=[0.1 0.3 1.0 5.0]
%             Args.timestep=timestep;
%             for beta=[0.0 0.5 2.0 10.0]
%                 Args.beta=beta;
%                 for gamma=[0.0 0.5 2.0 10.0]
%                     Args.gamma=gamma;
%                     Args.foldername_experiment =['ACMGMMsemi' '_nu' num2str(Args.nu) '_beta' num2str(Args.beta) '_gamma' num2str(Args.gamma) '_timestep' num2str(Args.timestep) '_' datestr(now,'ddHHMMSS')];
%                     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                     segmentation_func(Args);
%                 end
%             end
%         end
%     end
% end



%% ACM_semisupervised_HuangTan 在 不同初始化条件下、不同 Eacm 的权重下
% Args.evolutionMethod='semiACM_HuangTan';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for j=[1,50,100,200,300,500,1000,5000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%




%% unsupervised segmentation

% ACM and unsupervised

% folderpath_EachImageInitBaseFolder_2{1} = '.\data\ACMGMMSEMI\MSRA1K\init resources\kmeans100';
% folderpath_EachImageInitBaseFolder_2{2} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_SDF_kmeans100'; % 不推荐
folderpath_EachImageInitBaseFolder_2{3} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_staircase_kmeans100'; % 推荐


Args.markType='scribble';


%% ACMGMM 在 不同初始化条件下、不同停机条件下
Args.evolutionMethod='ACMGMM';
Args=initSegmentationMethod(Args, Args.evolutionMethod);
for i=folderpath_EachImageInitBaseFolder_2
    if isempty(i{1})
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=i{1};
    for endloop=[0.001,0.0001]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% LIF 在不同 初始化条件下、停机条件下
% Args.evolutionMethod='LIF';
% Args=initSegmentationMethod(Args, Args.evolutionMethod);
% for i=folderpath_EachImageInitBaseFolder_2
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for endloop=[0.001,0.0003,0.0001]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =[Args.evolutionMethod '_EndLoop' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end







%% end
text=['程序全部运行完毕。'];
% sp.Speak(text);





