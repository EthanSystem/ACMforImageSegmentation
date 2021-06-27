%% 用于分割的主程序
% 实验1：全监督ACMGMM的实验系列：ACMGMM、CV、GMM、LIF处理1000张图像。



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
% folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K\init resources\circle_SDF_ACMGMM';
folderpath_EachImageInitBaseFolder{2} = '.\data\resources\MSRA1K\init resources\circle_SDF_kmeans100';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K\init resources\kmeans100';
Args.folderpath_ResultsBaseFolder = '.\data\expr_1000images\segmentations' ;

Args.markType='contour';

%% %%%% 初始全局设置项 %%%%%%
initSegmentationArgsFirst;
% Args.timestep=0.10;  % time step, default = 0.10
Args.numIteration_outer = 1000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-20;  % 允许添加的防止除法运算误差最小数。
Args.proportionPixelsToEndLoop = 0.00100 ; % 设置演化循环停止条件：当两次相邻迭代之间，前背景的像素数改变的数量占所有像素数量的比例值小于设定值时则停止。值域[0,1]。默认 0.00100 。
Args.isNotWriteDataAtAll = 'no' ; % 程序运行过程中产生的结果数据是否保存，如果 'yes'，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.periodOfWriteData = 1 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10


%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%



% %% 使用 ACMGMM 方法
% Args.evolutionMethod='ACMGMM';
% 
% %% ACMGMM 参数设置
% % probability term
% Args.timestep=0.1;  % time step, default = 0.10
% Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
% Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
% Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
% Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
% Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
% 
% % 以下不需要改
% Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
% Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
% Args.initializeType = 'SDF' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
% Args.contoursInitValue =1 ;    % the value used for initialization contours.
% 
% % 以下不能改
% Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
% Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
% 
% 
% 
% 
% %% ACMGMM  在不同停机条件下
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.0010 0.0001 0.0003]
%         Args.proportionPixelsToEndLoop = endloop;
%         for epsilon=[0.5] % epsilon=[0.5 0.2]
%             Args.epsilon = epsilon;
%             for sigma=[1.5] % sigma=[1.5 0.3]
%                 Args.sigma = sigma;
%                 Args.foldername_experiment =[ ...
%                     'ACMGMM'...
%                     '_el' num2str(Args.proportionPixelsToEndLoop) ...
%                     '_epsilon' num2str(Args.epsilon) ...
%                     '_sigma' num2str(Args.sigma) ...
%                     '_' datestr(now,'ddHHMM') ...
%                     ];
%                 Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                 segmentation_func(Args);
%             end
%         end
%     end
% end


%
% %% 使用 CV 方法
% Args.evolutionMethod='CV';
%
% %% CV 参数设置
% Args.timestep = 0.10;	% time step .default=0.1.
% Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
% Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
% Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
% Args.beta = 0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.06*255*255
% Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
%
% % 以下不需要改
% Args.heavisideFunctionType = '2'; % heaviside函数的类型
% Args.initializeType = 'SDF' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
%
% Args.contoursInitValue = 1;    % the value used for initialization contours.
%
% % 以下不能改
% Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
%
% %% CV 在不同停机条件下
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['CV' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%
% %% 使用 GMM 方法
% Args.evolutionMethod='GMM';
%
% %% GMM 参数设置
% % 以下不能改
% Args.numOfComponents = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
% Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
% Args.initializeType = 'no' ;
%
%
% %% GMM 在不同停机条件下
% Args = setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for init=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(init{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=init{1};
%     for endloop=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop = endloop;
%         Args.foldername_experiment =['GMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end
%

%% 使用 LIF 方法
Args.evolutionMethod='LIF';

%% LIF 参数设置
% 参数组1
Args.timestep = 0.025;	% time step . default=0.005.
Args.epsilon = 1 ;		% papramater that specifies the width of the Heaviside function. default = 1.
Args.beta = 0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255*255
Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
Args.hsize = 15 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
Args.sigma_phi = 0.45 ; % the variance of regularized Gaussian kernel, default > sqrt(timestep). 0.45 - 1.00 .
Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
% 以下不需要改
Args.heavisideFunctionType = '2'; % heaviside函数的类型
Args.initializeType = 'SDF' ;
% 'user' 表示用自定义轮廓生成阶跃函数
% 'SDF' 表示用经典距离函数

Args.contoursInitValue = 1;    % the value used for initialization contours.

% 以下不能改
Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。

%% LIF 在不同停机条件下
Args = setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.0001 0.0010 0.0003]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['LIF' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end









%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















