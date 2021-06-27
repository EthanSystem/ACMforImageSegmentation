function [Args] = initSegmentationMethod(Args, evolutionMethod )
% setEvolutionMethod 设置指定的方法的参数。
% input:
% Args:
% evolutionMethod:
% output:
% Args:

%   此处显示详细说明
Args.evolutionMethod = evolutionMethod;
switch Args.evolutionMethod
    
    case 'semiACMGMMSP_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 3.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
        Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        % 划分的超像素的边长
        Args.SuperPixels_lengthOfSide = 10 ;
        
        % 划分的超像素的规则度
        Args.SuperPixels_regulation = 1.0 ;
        
        % 颜色特征子和空间特征子的权重
        Args.weight_feature = 0.5;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值
        
        % number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
        Args.numNearestNeighbors = 10;
%         % 高斯核带宽参数
%         Args.Sigma1=0.15;
        
        
        
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
        Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
        Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。
        Args.numIteration_SP = 3 ;  % 超像素级别演化循环次数，默认为 3
        
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
        
        
    case 'semiACMGMMSP_2_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.1 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 3.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
        Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        % 划分的超像素的边长
        Args.SuperPixels_lengthOfSide = 10 ;
        
        % 划分的超像素的规则度
        Args.SuperPixels_regulation = 1.0 ;
        
        % 颜色特征子和空间特征子的权重
        Args.weight_feature = 0.5;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值
        
        % number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
        Args.numNearestNeighbors = 10;
%         % 高斯核带宽参数
%         Args.Sigma1=0.15;
        
        
        
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
        Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
        Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。
        Args.numIteration_SP = 3 ;  % 超像素级别演化循环次数，默认为 3
        
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
        
    case 'semiACMGMMSP_1'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 5.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
        Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        % 划分的超像素的边长
        Args.SuperPixels_lengthOfSide = 10 ;
        
        % 划分的超像素的规则度
        Args.SuperPixels_regulation = 1.0 ;
        
        % 颜色特征子和空间特征子的权重
        Args.weight_feature = 0.5;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值
        
        % number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
        Args.numNearestNeighbors = 10;
%         % 高斯核带宽参数
%         Args.Sigma1=0.15;
        
        
        
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
        
    case 'semiACMGMMSP_1_2'
        %% parameters settings
        % probability term
        Args.timestep=0.10 ;  % time step, default = 0.10
        Args.epsilon = 0.2 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.lambda = 5.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
        Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        % 划分的超像素的边长
        Args.SuperPixels_lengthOfSide = 10 ;
        
        % 划分的超像素的规则度
        Args.SuperPixels_regulation = 1.0 ;
        
        % 颜色特征子和空间特征子的权重
        Args.weight_feature = 0.5;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值
        
        % number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
        Args.numNearestNeighbors = 10;
%         % 高斯核带宽参数
%         Args.Sigma1=0.15;
        
        
        
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
        
        
    case 'semiACMGMM'
        %% ACM_semisupervised
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
        
        
    case 'semiACMGMM_Eacm'
        %% ACMGMM_semisupervised_Eacm
        % probability term
        Args.timestep=0.1;  % time step, default = 0.10
        Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
        Args.beta =0.5; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
        Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
        Args.nu = 10; % coefficient of the weighted E_ACM term. default=10;
        Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        % 以下不需要改
        Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
        Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
        %         Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'staircase' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        Args.scaleOflabeledProbabilities = 2.0;  % 图像的有标记样本的概率值比未标记样本的概率值的最大值（最小值）还要大（小）的比例值，默认扩缩 2.0 倍。
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.isMinMaxInitContours = 'yes';   % 是否设置水平集嵌入函数的初始上下限值
        Args.contoursInitMinValue = -1;   % 水平集初始嵌入函数的下限值。
        Args.contoursInitMaxValue = 1;   % 水平集初始嵌入函数的上限值。
        
        % 以下不能改
        Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
        Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        
        
        
    case 'semiACM_Eacm'
        %% TODO
        
        
        
    case 'semiACM_HuangTan'
        %% TODO
        Args.timestep=5;  % time step, default = 5
        Args.lambda =  5;  % lambda: coefficient of the weighted length term L(\phi)
        Args.mu =  0.2/Args.timestep;  %   mu: coefficient of the internal (penalizing) energy term P(\phi)
        Args.alf = 1.5; %   alf: coefficient of the weighted area term A(\phi), choose smaller alf
        Args.epsilon = 1.5 ; %   epsilon: the papramater in the definition of smooth Dirac function, default value is 1.5
        Args.weight_Eacm = 10 ;  % weight of new regulation term, default value is 10
        Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 15 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        Args.initializeType ='staircase'; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        Args.contoursInitValue = 4 ;    % the value used for initialization contours.
        
    case 'ACM_SP'
        %% parameters settings
        % 划分的超像素的边长
        Args.SuperPixels_lengthOfSide=20;
        % 划分的超像素的规则度
        Args.SuperPixels_regulation=1.0;
        % 特征子的直方图的柱数
        Args.numBins=16;
        % 颜色特征子和空间特征子的权重
        Args.weight_feature = 0.5;  % 权重值 表示颜色特征子的权重值，(1-权重值) 表示空间特征子的权重值
        
        % number of nearest neighbors . 建议不要赋值太大，目前的程序还没有改进，否则容易报错
        Args.numNearestNeighbors=10;
        % 高斯核带宽参数
        Args.Sigma1=0.15;
        
        Args.sigma= 1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        Args.hsize= 5 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        
        
        % 颜色空间
        % 可选值有 'RGB' 'LAB' 'HSV' 三者之一
        Args.colorspace='LAB';
        % 超像素力的类型，'SP'，'DEF'，'SP DEF'三者选一
        Args.forceType= 'SP DEF';
        
        % 水平集演化参数
        % 演化步进值
        Args.timestep= 1.0; % time step
        Args.epsilon= 1.5; % the papramater in the definition of smoothed Dirac function
        Args.mu= 0.2/Args.timestep;  % coefficient of the internal (penalizing) energy term P(\phi)
        Args.lambda=5; % coefficient of the weighted length term Lg(\phi)
        Args.alpha=1.5; % coefficient of the weighted area term Ag(\phi);
        Args.weight_Fdata = 1.0 ; % coefficeint of the weighted F_data term;
        
        
        
        
        % 是否设置以下参数有待探究
        % 轮廓的初始化
        % 可以用任一方式初始化，'BOX'、'USER' 二者选择一个
        Args.contourType='USER';
        Args.boxWidth=20;
        Args.contoursInitValue =1 ;    % the value used for initialization contours.
        Args.isMinMaxInitContours = 'yes';   % 是否设置水平集嵌入函数的初始上下限值
        Args.contoursInitMinValue = -1;   % 水平集初始嵌入函数的下限值。
        Args.contoursInitMaxValue = 1;   % 水平集初始嵌入函数的上限值。
        
        % % 是否可视化的开关
        Args.isVisualEvolution='no';
        Args.isVisualSegoutput='no';
        Args.isVisualSPDistanceMat='no';
        Args.isVisualProbability='no';
        Args.isVisualSspc='no';
        
        Args.isVisual_f_data='no';
        Args.isVisualLabels='no';
        
        
        
        
    case 'ACMGMM'
        % probability term
        Args.timestep=0.1;  % time step, default = 0.10
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
        
        % 以下不能改
        Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
        Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        
        
    case 'CV'
        Args.timestep = 0.10;	% time step .default=0.1.
        Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
        Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
        Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
        Args.beta =0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.06*255*255
        Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        
        % 以下不需要改
        Args.heavisideFunctionType = '2'; % heaviside函数的类型
        Args.initializeType = 'staircase' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        Args.contoursInitValue = 1;    % the value used for initialization contours.
        
        % 以下不能改
        Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        
        
        
        % 	case 'ACMGMMpi1'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon = 0.05 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
        % 		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
        %
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
        %
        % 		% 以下不能改
        % 		Args.piType='1';   % pi的类型，'1' 表示式子(23)描述的。
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        %
        %
        %
        %
        %
        % 	case 'ACMGMMpi2'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon = 1.00 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
        % 		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
        %
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
        %
        % 		% 以下不能改
        % 		Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        %
        %
        %
        %
        % 	case 'ACMandGM'
        % 		% probability term
        % 		Args.timestep=0.10;  % time step
        % 		Args.epsilon=1.00;		% papramater that specifies the width of the DiracDelta function. default=1.00.
        % 		Args.mu = 1.0;			% coefficeient of the weighted probability term prob(phi).
        % 		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.00 .
        %
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '2'; % 选择heaviside函数的类型，default = '2'
        % 		Args.initializeType = 'user' ;		% 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
        % 		Args.contoursInitValue = 2;			% 初始化轮廓的值。仅对选择了采用自定义形状的梯度轮廓方法初始化轮廓有效。
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        % 		Args.numOfComponents = 1;	% 所有的GMM分枝数，在本算法中=1，在本方法分枝数就是1，但是有两个GMM，一个表示前景，一个表示背景，否则这个方法就不是这个方法了
        
        
        
    case 'GMM'
        % 以下不能改
        Args.numOfComponents = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
        Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        Args.initializeType = 'no' ;
        
        % 	case 'LBF'
        % 		Args.timestep = 0.1;	% time step .default=0.1.
        % 		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%控制符号距离函数权值。default =1.0
        % 		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta = 2.0;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
        % 		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
        % 		Args.hsize=round(2*Args.sigma)*2+1 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '2'; % heaviside函数的类型
        % 		Args.initializeType = 'user' ;
        % 		% 'user' 表示用自定义轮廓生成阶跃函数
        % 		% 'SDF' 表示用经典距离函数
        %
        % 		Args.contoursInitValue = 2;    % the value used for initialization contours.
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        %
        %
        %
        %
        %
        %
        %
        % 	case 'LBFgray'
        % 		Args.timestep = 0.1;	% time step .default=0.1.
        % 		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%控制符号距离函数权值。default =1.0
        % 		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta =0.001*255*255;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
        % 		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
        % 		Args.hsize=round(2*Args.sigma)*2+1 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '2'; % heaviside函数的类型
        % 		Args.initializeType = 'user' ;
        % 		% 'user' 表示用自定义轮廓生成阶跃函数
        % 		% 'SDF' 表示用经典距离函数
        %
        % 		Args.contoursInitValue = 2;    % the value used for initialization contours.
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        
        
    case 'LIF'
        % 参数组1
        Args.timestep = 0.050;	% time step . default=0.005.
        Args.epsilon = 1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
        Args.beta = 0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255*255
        Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
        Args.hsize = 15.0 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
        Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
        Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
        % 以下不需要改
        Args.heavisideFunctionType = '2'; % heaviside函数的类型
        Args.initializeType = 'staircase' ;
        % 'user' 表示用自定义轮廓生成阶跃函数
        % 'SDF' 表示用经典距离函数
        
        Args.contoursInitValue = 1;    % the value used for initialization contours.
        
        % 以下不能改
        Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        
        
        
        
        
        
        % 	case 'LIFgray'
        % 		Args.timestep = 0.1;	% time step . default=0.005.
        % 		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.mu = 1;	%控制符号距离函数权值。default =1.0
        % 		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
        % 		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
        % 		Args.hsize=15;			% 高斯滤波器的模板大小，default=15 or 2*round(2*Args.sigma)*2+1, also means 15 x 15.
        % 		Args.sigma_phi = 1.5 ; % the variance of regularized Gaussian kernel
        % 		Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '2'; % heaviside函数的类型
        % 		Args.initializeType = 'user' ;
        % 		% 'user' 表示用自定义轮廓生成阶跃函数
        % 		% 'SDF' 表示用经典距离函数
        %
        % 		Args.contoursInitValue = 2;    % the value used for initialization contours.
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        %
        %
        % 	case 'ACMandGMMtoEq18'
        % 		Args.timestep = 0.10;  % time step
        % 		Args.epsilon = 0.05; % papramater that specifies the width of the DiracDelta function.
        % 		Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
        % 		Args.beta = 0.50; % coefficeient of the weighted length term L(phi). default=0.5.
        % 		Args.gamma = 0.00;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        % 		Args.heavisideFunctionType = '2'; % 选择heaviside函数的类型
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        % 		Args.initializeType = 'SDF' ;		% 选择嵌入函数初始化方式
        % 		Args.contoursInitValue = 2;   % the value used for initialization contours.
        % 		Args.numOfComponents = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
        %
        %
        %
        %
        % 	case 'CVgray'
        % 		Args.timestep = 0.10 ;	% time step .default=0.1.
        % 		Args.epsilon = 1 ;			% papramater that specifies the width of the Heaviside function. default = 1.
        % 		Args.lambda_1 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.lambda_2 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
        % 		Args.beta = 0.50 ;		% coefficeient of the weighted length term L(phi). default=0.5. ，or also 0.06*255^2
        % 		Args.gamma = 0.00 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
        %
        % 		% 以下不需要改
        % 		Args.heavisideFunctionType = '2' ; % heaviside函数的类型
        % 		Args.initializeType = 'SDF'  ;
        % 		Args.contoursInitValue = 2 ;    % the value used for initialization contours.
        %
        % 		% 以下不能改
        % 		Args.isNeedInitializingContourByLSMethod = 'yes' ;  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        %
        %
        %
        %
        % 	case 'DRLSE'
        % 		Args.timestep=5.0;  % time step. default is 5.0
        %
        % 		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
        % 		Args.initializeType = 'user' ;
        % 		Args.contoursInitValue = 2;		% the value used for initialization contours.
        %
        % 		Args.heavisideFunctionType = '3'; % heaviside函数的类型 .default is '3'
        % 		Args.mu=0.2/Args.timestep;  % coefficient of the distance regularization term R(phi) , default is 0.2/Args.timestep or 0.04.
        % 		Args.lambda=5.0; % coefficient of the weighted length term L(phi) , default is 5.0 .
        % 		Args.alfa=1.5;  % coefficient of the weighted area term A(phi) , default is 1.50 .
        % 		Args.epsilon=1.5; % papramater that specifies the width of the DiracDelta function, default is 1.50 .
        % 		Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
        % 		Args.hsize=15 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
        %
        % 		% potential function
        % 		% use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model
        % 		% or use double-well potential in Eq. (16), which is good for both edge and region based models
        % 		% or use default choice of potential function .
        % 		Args.potentialFunction = 'double-well';
        
        
    otherwise
        error('error at choose evolution method !');
end

end

