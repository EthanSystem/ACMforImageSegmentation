%% 用于分割的主程序
% 实验2：半监督ACMGMM的实验系列：处理1000张图像。



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
folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\segmentations' ;

Args.markType='scribble';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 1000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-25;  % 允许添加的防止除法运算误差最小数。



%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% 使用 ACM_semisupervised 方法
Args.evolutionMethod='semiACMGMM';

%% ACM_semisupervised 参数设置
% probability term
Args.timestep=0.10;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
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


%% ACMGMM_semisupervised  在不同停机条件下
Args = setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.00100 0.00030 0.00010]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMMsemi' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















