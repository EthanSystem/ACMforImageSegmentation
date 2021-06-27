%% 用于分割的主程序
% 实验3：引入超像素力的半监督ACMGMM的实验系列：对结果进行

%% 注意事项：
% 手动把文件夹“ACM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。

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



%% %%%% 初始全局设置项 %%%%%%
initSegmentationArgsFirst;


%% %%%%% 设置实验的初始参数区 %%%%%%%%%%%%%%%%%%%

%% 路径和其它初始化设置项
Args.folderpath_EachImageResourcesBaseFolder = '.\data\expr3_seg\毕业论文超像素可视化分析的\original resources';
folderpath_EachImageInitBaseFolder{1} = '.\data\expr3_seg\毕业论文超像素可视化分析的\init resources\scribbled_circle_SDF_kmeans100_2';
Args.folderpath_ResultsBaseFolder = '.\data\expr3_seg\毕业论文超像素可视化分析的\segmentation';

Args.markType='scribble';

Args.timestep=0.1;  % time step, default = 0.10
Args.numIteration_outer= 1000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-20;  % 允许添加的防止除法运算误差最小数。

Args.isRunArrayProcessedImages = 'yes' ; % 每种方法是否只运行在数列里的一部分图像。
Args.arrayProcessedImages = [3] ; % 每种方法运行的时候，处理数列里的一部分图像。

Args.isNotWriteDataAtAll = 'no' ; % 程序运行过程中产生的结果数据是否保存，如果 'yes'，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.isWriteData = 'no' ;		% 程序运行过程中产生的结果数据是否保存，但是最终结果数据还是要保存的。默认 'no'
Args.periodOfWriteData = 1 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10

%% %%%%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% 使用 ACMGMMandSPsemisupervised_1_2 方法
Args.evolutionMethod = 'semiACMGMMSP_1_2';

%% ACMGMMandSPsemisupervised_1_2 参数设置
% probability term
Args.timestep=0.10 ;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.

% 划分的超像素的边长
Args.SuperPixels_lengthOfSide = 10 ;

% 划分的超像素的规则度
Args.SuperPixels_regulation = 1.0 ;

% 颜色特征子和空间特征子的权重
Args.weight_feature = 1;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值

% number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
Args.numNearestNeighbors = 10;



% 颜色空间
% 可选值有 'RGB' 'LAB' 'HSV' 三者之一
Args.colorspace='RGB';
% 超像素力的类型，'SP'，'DEF'，'SP DEF'三者选一
Args.forceType= 'SP DEF';
% 选择计算超像素特征的方法，可用选项有： '1' ~ '5'
Args.SPFeatureMethod = '3' ;

% 以下不需要改
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
Args.piType = '2';   % pi的类型。'2' 表示式子(25)描述的。
Args.initializeType = 'SDF' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
Args.contoursInitValue = 1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。


% 以下不能改
Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。

% % 是否可视化的开关
Args.isVisualEvolution='no';
Args.isVisualSegoutput='no';
Args.isVisualSPDistanceMat='no';
Args.isVisualProbability='no';
Args.isVisualSspc='no';

Args.isVisual_f_data='no';
Args.isVisualLabels='no';


%% ACMGMMandSP_semisupervised_1  在不同停机条件下
Args=setSegmentationMethod(Args, Args.evolutionMethod);
i=0;
for init=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(init{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=init{1};
    for endloop=[0.00010]
        Args.proportionPixelsToEndLoop = endloop;
        Args.foldername_experiment =['ACMGMMSPsemi_1_stable' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMM')];
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end

%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















