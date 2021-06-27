%% 用于分割的主程序
% 实验3：引入超像素力的半监督ACMGMM的实验系列：
% semiACMandSP_1_2 调参试验

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



%% %%%% 初始全局设置项 %%%%%%
initSegmentationArgsFirst;
Args.timestep=0.10;  % time step, default = 0.10
Args.numIteration_outer = 1000  ;		% 外循环次数，default = 1000
Args.smallNumber=realmin + 1E-20;  % 允许添加的防止除法运算误差最小数。
Args.proportionPixelsToEndLoop = 0.00010 ; % 设置演化循环停止条件：当两次相邻迭代之间，前背景的像素数改变的数量占所有像素数量的比例值小于设定值时则停止。值域[0,1]。默认 0.00100 。
Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果 'yes'，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.periodOfWriteData = 1 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10


%% 路径设置项
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K 10 images\original resources';

folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K 10 images\init resources\scribbled_circle_SDF_kmeans100_2';

Args.folderpath_ResultsBaseFolder = '.\data\expr3_semiACMGMMSP_1_2_para\oldSP_one' ;

Args.markType='scribble';


%% %%%%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% 使用 ACMGMMandSPsemisupervised_1 方法
Args.evolutionMethod = 'semiACMGMMSP_1_2';

%% ACMGMMandSPsemisupervised_1 参数设置
% probability term
Args.timestep = 0.10 ;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma = 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize = 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.

% 划分的超像素的边长
Args.SuperPixels_lengthOfSide = 15 ;

% 划分的超像素的规则度
Args.SuperPixels_regulation = 1.0 ;

% 颜色特征子和空间特征子的权重
Args.weight_feature = 1.0;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值

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
Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
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


%% %%%%%%%%%%%%% 实验区 %%%%%%%%%%%%%%%%%%%%%%%%

%% ACMGMMandSPsemisupervised_1_2 测试分析专用 %%%%%%%%%%%%%%%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     Args.foldername_experiment =['semiACMGMMSP_1_2' '_' datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end

%% ACMGMMandSPsemisupervised_1_2 在 不同参数下的批处理试验1 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for colorspace={'RGB' 'LAB' 'HSV'}
%         Args.colorspace=colorspace{1};
%         for SuperPixels_lengthOfSide=[5 15]
%             Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%             for SuperPixels_regulation=[1.00 0.85 0.50]
%                 Args.SuperPixels_regulation=SuperPixels_regulation;
%                 for lambda=[100.0 010.0 001.0 000.1 000.0]
%                     Args.lambda=lambda;
%                     Args.foldername_experiment =[...
%                         'semiSP_1' ...
%                         '_piType' Args.piType ...
%                         '_color' Args.colorspace ...
%                         '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                         '_SPreg' num2str(Args.SuperPixels_regulation) ...
%                         '_step' num2str(Args.timestep) ...
%                         '_epsilon' num2str(Args.epsilon) ...
%                         '_lambda' num2str(Args.lambda)];
%                     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                     segmentation_func(Args);
%                 end
%             end
%         end
%     end
% end


%% ACMGMMandSPsemisupervised_1_2 在 不同参数下的批处理试验2 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for piType = {'1' '2'}
%         Args.piType = piType{1};
%         for colorspace={'RGB' 'LAB'}
%             Args.colorspace=colorspace{1};
%             for SuperPixels_lengthOfSide=[5 15]
%                 Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%                 for epsilon=[1.00 0.50 0.20 0.10 0.05]
%                     Args.epsilon=epsilon;
%                     for lambda=[100.0 010.0 001.0 000.1 000.0]
%                         Args.lambda=lambda;
%                         Args.foldername_experiment =[...
%                             'semiSP_1' ...
%                             '_piType' Args.piType ...
%                             '_color' Args.colorspace ...
%                             '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                             '_epsilon' num2str(Args.epsilon) ...
%                             '_lambda' num2str(Args.lambda)];
%                         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                         segmentation_func(Args);
%                     end
%                 end
%             end
%         end
%     end
% end
%


%% ACMGMMandSPsemisupervised_1_2 在 不同参数下的批处理试验3 %%%%%%%%%%%%%%
% i=0;
% idx_smallNumber=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for smallNumber=[realmin+1E-20 realmin+1E-25 realmin+1E-50 realmin+1E-100 realmin]
%         Args.smallNumber=smallNumber;
%         idx_smallNumber=idx_smallNumber+1;
%         for epsilon=[1.00 0.50 0.20]
%             Args.epsilon=epsilon;
%             for lambda=[010.0 001.0]
%                 Args.lambda=lambda;
%                 Args.foldername_experiment =[...
%                     'semiSP_1' ...
%                     '_smallNumber' num2str(idx_smallNumber) ...
%                     '_epsilon' num2str(Args.epsilon) ...
%                     '_lambda' num2str(Args.lambda)];
%                 Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                 segmentation_func(Args);
%             end
%         end
%     end
% end



%% ACMGMMandSPsemisupervised_1_2 在 不同参数下的批处理试验3 %%%%%%%%%%%%%%
i=0;
j=0;
idx_smallNumber=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    for el=[0.00100 0.00030 0.00010]
        j=j+1;
        Args.proportionPixelsToEndLoop=el;
        for lambda=[010.0 001.0 000.1]
            Args.lambda=lambda;
            Args.foldername_experiment =[...
                'semiSP_1' ...
                '_el' num2str(j) ...
                '_lambda' num2str(Args.lambda) ...
                ] ;
            Args = setSegmentationMethod(Args, Args.evolutionMethod);
            segmentation_func(Args);
        end
    end
end



%% end
% text=['程序全部运行完毕。'];
% sp.Speak(text);















