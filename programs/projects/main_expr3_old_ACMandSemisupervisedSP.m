%% 用于分割的主程序

% 实验2：引入超像素力的半监督ACMGMM的实验系列

%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。

%%

% 每次启动MATLAB后只需要运行一次。
VLROOTS='';
run('C:\Softwares\VLFeat\toolbox\vl_setup');
% vl_version verbose
% addpath of vl-feat. the pathname may be different in different PC.


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
Args.folderpath_EachImageResourcesBaseFolder = '.\data\ACMGMMSEMI\MSRA1K 10 images\original resources';
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K 10 images\segmentations\test analysis';

%% semi-supervised segmentation
% folderpath_EachImageInitBaseFolder_1{1} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K 4 images\init resources\scribbled_circle_staircase_kmeans100_2';

% folderpath_EachImageInitBaseFolder_1{1} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{2} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{3} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_staircase_kmeans100_1';
% folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_2';
% folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K 10 images\init resources\scribbled_circle_staircase_kmeans100_2';


%% 设置代数
% Args.numIteration_outer= 10  ;		% 外循环次数，default = 1000
% Args.numIteration_inner= 1 ;  % 内循环次数，default = 1




%% parameters settings
% probability term
Args.timestep=0.10 ;  % time step, default = 0.10
Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.00 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.

% 划分的超像素的边长
Args.SuperPixels_lengthOfSide = 15 ;

% 划分的超像素的规则度
Args.SuperPixels_regulation = 1.0 ;


%         % 高斯核带宽参数
%         Args.Sigma1=0.15;
%
%         Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
%         Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.


% 颜色空间
% 可选值有 'RGB' 'LAB' 'HSV' 三者之一
Args.colorspace='RGB';


% 以下不需要改
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。


% 以下不能改
Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。

%         % 是否设置以下参数有待探究
%         % 轮廓的初始化
%         % 可以用任一方式初始化，'BOX'、'USER' 二者选择一个
%         Args.contourType = 'USER';
%         Args.boxWidth=20;
%         Args.contoursInitValue =1 ;    % the value used for initialization contours.
%         Args.isMinMaxInitContours = 'yes';   % 是否设置水平集嵌入函数的初始上下限值
%         Args.contoursInitMinValue = -1;   % 水平集初始嵌入函数的下限值。
%         Args.contoursInitMaxValue = 1;   % 水平集初始嵌入函数的上限值。

% % 是否可视化的开关
Args.isVisualEvolution='no';
Args.isVisualSegoutput='no';
Args.isVisualSPDistanceMat='no';
Args.isVisualProbability='no';
Args.isVisualSspc='no';

Args.isVisual_f_data='no';
Args.isVisualLabels='no';



%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%


%% 测试分析专用
Args.foldername_experiment =['semiACMGMMSP' '_' datestr(now,'ddHHMMSS')];
Args = setSegmentationMethod(Args, Args.evolutionMethod);
segmentation_func(Args);



%% 试验：初始化方式的影响
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder_1
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     Args.foldername_experiment =['semiACMGMMandSP' '_init' num2str(i) '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% 试验：演化代数的影响
% for numIteration_outer=[10 100 1000]
%     Args.numIteration_outer=numIteration_outer;
%     Args.foldername_experiment =['semiACMGMMandSP' '_iter' num2str(numIteration_outer) '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% 试验：颜色空间、特征值计算方案 的影响
% for colorspace= {'LAB' 'HSV' 'RGB'}
%     Args.colorspace=colorspace{1};
%     for SPFeatureMethod={'2' '3'}
%         Args.foldername_experiment =['color' colorspace{1} '_feature' SPFeatureMethod{1} '_' datestr(now,'ddHHMMSS')];
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% evolution_ACMGMMandSPsemisupervised_2 在 不同参数下的批处理试验
% Args=setSegmentationMethod(Args, Args.evolutionMethod);
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder_1
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for SPFeatureMethod = {'2' '3'}
%         Args.SPFeatureMethod = SPFeatureMethod{1};
%         for colorspace={'LAB' 'HSV'}
%             Args.colorspace=colorspace{1};
%             for timestep=[0.1 0.3]
%                 Args.timestep=timestep;
%                 for weight_feature=[0.00 0.01 0.10 0.25 0.50 0.75 0.90 0.99 1.00]
%                     Args.weight_feature = weight_feature;
%                     for beta=[0.0 0.3 5.0]
%                         Args.beta=beta;
%                         for gamma=[0.0 0.3 5.0]
%                             Args.gamma=gamma;
%                             Args.foldername_experiment =['ACMGMMsemi' '_init' num2str(i) '_feature' num2str(Args.SPFeatureMethod) '_color' num2str(Args.colorspace) '_timestep' num2str(Args.timestep) '_wf' num2str(Args.weight_feature) '_beta' num2str(Args.beta) '_gamma' num2str(Args.gamma)];
%                             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                             segmentation_func(Args);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end



%% end
text=['程序全部运行完毕。'];
sp.Speak(text);















