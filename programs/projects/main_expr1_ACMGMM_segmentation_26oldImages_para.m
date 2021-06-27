%% 用于分割的主程序
% 实验1：全监督ACMGMM的实验系列：ACMGMM 处理 26 张原来论文的图像的调参。



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
Args.folderpath_EachImageResourcesBaseFolder = '.\data\expr1_ACMGMM_原来论文的图\original resources';
folderpath_EachImageInitBaseFolder{1} = '.\data\expr1_ACMGMM_原来论文的图\init resources\circle_SDF_kmeans100';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K\init resources\kmeans100';
Args.folderpath_ResultsBaseFolder = '.\data\expr1_ACMGMM_原来论文的图\segmentations' ;

Args.markType='contour';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 001000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-20;  % 允许添加的防止除法运算误差最小数。



%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%



%% 使用 ACMGMM 方法
Args.evolutionMethod='ACMGMM';

%% ACMGMM 参数设置
% probability term
Args.timestep=0.1;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.

% 以下不需要改
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
Args.initializeType = 'SDF' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
Args.contoursInitValue =1 ;    % the value used for initialization contours.

% 以下不能改
Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。




%% ACMGMM  在不同停机条件下
Args = setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.0010 0.0003 0.0001]
        Args.proportionPixelsToEndLoop = endloop;
        for epsilon=[0.5 0.2]
            Args.epsilon = epsilon;
            for sigma=[1.5 0.3]
                Args.sigma = sigma;
                for hsize=[15 5]
                    Args.hsize = hsize;
                    Args.foldername_experiment =[ ...
                        'ACMGMM' ...
                        '_el' num2str(Args.proportionPixelsToEndLoop) ...
                        '_epsilon' num2str(Args.epsilon) ...
                        '_sigma' num2str(Args.sigma) ...
                        '_hsize' num2str(Args.hsize) ...
                        '_' datestr(now,'ddHHMM') ...
                        ];
                    Args = setSegmentationMethod(Args, Args.evolutionMethod);
                    segmentation_func(Args);
                end
            end
        end
    end
end


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
%
% %% 使用 LIF 方法
% Args.evolutionMethod='LIF';
%
% %% LIF 参数设置
% % 参数组1
% Args.timestep = 0.050;	% time step . default=0.005.
% Args.epsilon = 1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
% Args.beta = 0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255*255
% Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
% Args.hsize = 15.0 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
% Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
% Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
% % 以下不需要改
% Args.heavisideFunctionType = '2'; % heaviside函数的类型
% Args.initializeType = 'staircase' ;
% % 'user' 表示用自定义轮廓生成阶跃函数
% % 'SDF' 表示用经典距离函数
%
% Args.contoursInitValue = 1;    % the value used for initialization contours.
%
% % 以下不能改
% Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
%
% %% LIF 在不同停机条件下
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
%         Args.foldername_experiment =['LIF' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end









%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















