%% 用于分割的主程序
% 实验1：ACMGMM的实验系列：LIF方法的调参试验

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



%% %%%% 初始全局设置项 %%%%%%
initSegmentationArgsFirst;
% Args.timestep=0.10;  % time step, default = 0.10
Args.numIteration_outer = 010000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-20;  % 允许添加的防止除法运算误差最小数。
Args.proportionPixelsToEndLoop = 0.0010 ; % 设置演化循环停止条件：当两次相邻迭代之间，前背景的像素数改变的数量占所有像素数量的比例值小于设定值时则停止。值域[0,1]。默认 0.00100 。
Args.isNotWriteDataAtAll = 'no' ; % 程序运行过程中产生的结果数据是否保存，如果 'yes'，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.periodOfWriteData = 100 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10

%% 路径设置项
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K 6 images\original resources';

folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K 6 images\init resources\circle_SDF_kmeans100';
% folderpath_EachImageInitBaseFolder{2} = '.\data\resources\MSRA1K 6 images\init resources\circle_staircase_kmeans100';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K 6 images\init resources\kmeans100';
% folderpath_EachImageInitBaseFolder{4} = '.\data\resources\MSRA1K 6 images\init resources\circle_SDF_ACMGMM';

Args.folderpath_ResultsBaseFolder = '.\data\test segmentations' ;

Args.markType='contour';




%% %%%%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% 使用 LIF 方法
Args.evolutionMethod = 'LIF';

%% LIF 参数设置
% 参数组1
Args.timestep = 10.0;	% time step . default=0.005.
Args.epsilon =1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
Args.beta = 65;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255*255
Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
Args.hsize =15 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
Args.sigma_phi = 0.5 ; % the variance of regularized Gaussian kernel, default > sqrt(timestep). 0.45 - 1.00 .
Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
% 以下不需要改
Args.heavisideFunctionType = '2'; % heaviside函数的类型
Args.initializeType = 'SDF' ;
% 'user' 表示用自定义轮廓生成阶跃函数
% 'SDF' 表示用经典距离函数

Args.contoursInitValue = 1;    % the value used for initialization contours.

% 以下不能改
Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。

%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% LIF 测试分析专用 %%%%%%%%%%%%%%%%%%%%%%%%%%%
i=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    Args.foldername_experiment =['LIF' '_' datestr(now,'ddHHMMSS')];
    Args = setSegmentationMethod(Args, Args.evolutionMethod);
    segmentation_func(Args);
end

%% LIF 在 不同参数下的批处理试验1 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for timestep=[0.00500 0.05000 0.50000]
%         j=j+1;
%         Args.timestep=timestep;
%         for epsilon=[0.1 0.5 2.5]
%             Args.epsilon=epsilon;
%             for beta=[0.5 2.5 65]
%                 Args.beta=beta;
%                 for sigma=[0.3 1 3 10]
%                     Args.sigma=sigma;
%                     for hsize=[5 15]
%                         Args.hsize=hsize;
%                         for sigma_phi=[0.3 1.0 3.0]
%                             Args.sigma_phi=sigma_phi;
%                             for hsize_phi=[5 15]
%                                 Args.hsize_phi=hsize_phi;
%                                 Args.foldername_experiment =[...
%                                     'LIF' ...
%                                     '_time' num2str(Args.timestep) ...
%                                     '_epsilon' num2str(Args.epsilon) ...
%                                     '_beta' num2str(Args.beta) ...
%                                     '_sigma' num2str(Args.sigma) ...
%                                     '_hsize' num2str(Args.hsize) ...
%                                     '_sigmaPhi' num2str(Args.sigma_phi) ...
%                                     '_hsizePhi' num2str(Args.hsize_phi) ...
%                                     ] ;
%                                 Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                                 segmentation_func(Args);
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end


%% LIF 在 不同参数下的批处理试验2 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for timestep=[0.100 0.050 0.005 0.500]
%         j=j+1;
%         Args.timestep=timestep;
%         for epsilon=[65 0.5 0.1 2.5]
%             Args.epsilon=epsilon;
%             Args.foldername_experiment =[...
%                 'LIF' ...
%                 '_time' num2str(Args.timestep) ...
%                 '_epsilon' num2str(Args.epsilon) ...
%                 ] ;
%             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%             segmentation_func(Args);
%         end
%     end
% end





%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















