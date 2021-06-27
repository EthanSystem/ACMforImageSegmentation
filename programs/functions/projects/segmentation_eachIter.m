%% 简介：
% 用于对一批图像用不同的分割算法分割图像并生成相应结果。用于后续分析。程序每次运行调用一种分割算法的给定的一组参数值处理一批图像。
% Reference :
...Guowei Gao ,Chenglin Wen ,Huibin Wang, Fast and robust image segmentation with active contours and Student's-t mixture model
	
...资源放在 resources 文件夹中
	...结果放在 results 文件夹中
	
%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
% addpath( genpath( '.' ) ); %添加当前路径下的所有文件夹以及子文件夹


%% 用户输入初始参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args 结构体里的字段表示程序运行前手动设置的参数

% 选择演化模式
...'ACMGMM'		基于[1]的新方法
	... 'ACMGMMpi1'                          基于[1]的方法的变种的第一种先验信息的计算方式
	...'ACMGMMpi2'					基于[1]的方法的变种的第二种先验信息的计算方式
	...'ACMandGM'							导师提供的第二章部分的方法。。。
	...'ACMandGMMtoEq18'                      借鉴[1]的方法，但是不引入关于(23)(25)式的先验信息，而只用到(18)
	...'GMM'										GMM 的传统方法
	...'DRLSE'									    DRLSE模型。此方法由以下提供 C. Li, C. Xu, C. Gui, M. D. Fox, "Distance Regularized Level Set Evolution and Its Application to Image Segmentation", IEEE Trans. Image Processing, vol. 19 (12), pp.3243-3254, 2010....的方法
	...'CV'											CV模型方法，用于彩色图。Chan, T. F. and B. Y. Sandberg, et al. (2000). "Active Contours without Edges for Vector-Valued Images." Journal of Visual Communication and Image Representation 11 (2): 130-141.
	% 	...'LBF'							LBF方法，用于彩色图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
...'LIF'								LIF方法，用于彩色图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
	...'CVgray'											CV模型方法。reference: Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
	...'LBFgray'							LBF方法，用于灰度图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
	...'LIFgray'								LIF方法，用于灰度图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
	Args.evolutionMethod = 'ACMGMM' ;	% 选择演化模型

Args.markType = 'contour' ;	% 选择标记类型，表示用什么类型的交互式标记进行分割。可选 'original' 'contour' 'scribble'。'original' 表示不用交互式标记，直接用原图。'contour' 表示用别的方式初始化的轮廓图作为初始化。'scribble' 表示用交互式
Args.initMethod = 'circle+ACMGMM' ; % 选择初始化类型，表示用什么类型的初始化方法。可选 'circle' 'kmeans' 'kmeans+ACMGMM' 'circle+ACMGMM'
Args.maxIterOfKmeans = 100; % 用 k-means 初始化的时候的最大迭代次数。

% Args.foldername_EachImageBaseFolder = '.\data\resources\temp_circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\temp_circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_EachImageBaseFolder = '.\data\resources\temp_circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\temp_circle';
Args.foldername_EachImageBaseFolder = '.\data\resources\circleACMGMM_epsilon0.5_sigma0.3';
Args.foldername_ResultsBaseFolder = '.\data\segmentations\circleACMGMM_epsilon0.5_sigma0.3';
% Args.foldername_EachImageBaseFolder = '.\data\resources\circle';
% Args.foldername_ResultsBaseFolder = '.\data\segmentations\circle';

Args.isNotVisiualEvolutionAtAll = 'yes' ; % 程序运行过程中是否完全不可视化中间过程和保存中间过程图 。默认 'yes'
Args.isVisualEvolution = 'no' ;	% 程序运行过程中是否可视化显示结果图，但是最终结果图还是要可视化和保存的。默认 'no'
Args.periodOfVisual = 10 ;	% 可视化显示结果图的迭代次数周期，即每隔几代显示一次结果图。默认 10

Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果是，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.isWriteData = 'no' ;		% 程序运行过程中产生的结果数据是否保存，但是最终结果数据还是要保存的。默认 'no'
Args.periodOfWriteData = 1 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10

Args.isVoice = 'no' ;		% 程序运行过程中是否声音提示，默认 'no'

Args.circleRadius=100; % setting radius of contour circle if you use SDF to initiate a phi function

% 设置停机条件
Args.proportionPixelsToEndLoop = 0.00100 ; % 设置演化循环停止条件：当两次相邻迭代之间，前背景的像素数改变的数量占所有像素数量的比例值小于设定值时则停止。值域[0,1]
Args.numIteration_inner=1 ;				% 内循环次数，default = 1
Args.iteration_inner=1 ;						% 内循环初始值，default = 1
Args.numIteration_outer= 1000  ;		% 外循环次数，default = 1000
Args.iteration_outer=1 ;						% 外循环初始值，default = 1
Args.numTime = 3.0 ;			% 每个图像处理的最大固定时间，如果超过这个时间则在该迭代结束之后停止循环。

Args.outputMode = 'datatime';	% 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index' 表示实验文件夹名称是编号。默认 'datatime' 。推荐用默认值。

Args.numUselessFiles = 0;   % 有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除无用文件的数量。但是此功能有bug。



switch Args.evolutionMethod
	case 'ACMGMM'
		% probability term
		Args.timestep=0.10;  % time step, default = 0.10
		Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta =0.50; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
		Args.gamma=0.0;  % coefficient of the weighted area term A(phi). default=0.2.
		Args.sigma= 0.3;     % scale parameter in Gaussian kernel , default is 1.5 .
		Args.hsize= 15 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
		
		% 以下不需要改
		Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
		Args.initializeType = 'user' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
		
		% 以下不能改
		Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
		
	case 'ACMGMMpi1'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon = 0.05 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
		
		% 以下不需要改
		Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
		
		% 以下不能改
		Args.piType='1';   % pi的类型，'1' 表示式子(23)描述的。
		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
		
	case 'ACMGMMpi2'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon = 1.00 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at [1].
		Args.mu = 1.00;  % coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
		
		% 以下不需要改
		Args.heavisideFunctionType = '1'; % 选择heaviside函数的类型，default = '1'
		
		% 以下不能改
		Args.piType='2';   % pi的类型。'2' 表示式子(25)描述的。
		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
	case 'ACMandGM'
		% probability term
		Args.timestep=0.10;  % time step
		Args.epsilon=1.00;		% papramater that specifies the width of the DiracDelta function. default=1.00.
		Args.mu = 1.0;			% coefficeient of the weighted probability term prob(phi).
		Args.beta=0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.00 .
		
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % 选择heaviside函数的类型，default = '2'
		Args.initializeType = 'user' ;		% 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
		Args.contoursInitValue = 2;			% 初始化轮廓的值。仅对选择了采用自定义形状的梯度轮廓方法初始化轮廓有效。
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		Args.numOfComponents = 1;	% 所有的GMM分枝数，在本算法中=1，在本方法分枝数就是1，但是有两个GMM，一个表示前景，一个表示背景，否则这个方法就不是这个方法了
		
		
		
		
	case 'CV'
		Args.timestep = 0.10;	% time step .default=0.1.
		Args.epsilon = 0.5;			% papramater that specifies the width of the Heaviside function. default = 1.
		Args.lambda1 = 1;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta =0.50;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.06*255*255
		Args.gamma = 0 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % heaviside函数的类型
		Args.initializeType = 'user' ; % 选择嵌入函数初始化方式。 'user' 表示用自定义轮廓生成阶跃函数，'SDF' 表示用经典距离函数
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
	case 'GMM'
		% 以下不能改
		Args.numOfComponents = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		Args.initializeType = 'no' ;
		
		
	case 'LBF'
		Args.timestep = 0.1;	% time step .default=0.1.
		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%控制符号距离函数权值。default =1.0
		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta = 2.0;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
		Args.hsize=round(2*Args.sigma)*2+1 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % heaviside函数的类型
		Args.initializeType = 'user' ;
		% 'user' 表示用自定义轮廓生成阶跃函数
		% 'SDF' 表示用经典距离函数
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
		
		
		
	case 'LBFgray'
		Args.timestep = 0.1;	% time step .default=0.1.
		Args.epsilon = 1.00;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%控制符号距离函数权值。default =1.0
		Args.lambda1 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda2 = 1.0;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta =0.001*255*255;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
		Args.sigma= 3.0;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
		Args.hsize=round(2*Args.sigma)*2+1 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % heaviside函数的类型
		Args.initializeType = 'user' ;
		% 'user' 表示用自定义轮廓生成阶跃函数
		% 'SDF' 表示用经典距离函数
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
	case 'LIF'
		% 参数组1
		Args.timestep = 0.1;	% time step . default=0.005.
		Args.epsilon = 0.5 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%控制符号距离函数权值。default =1.0
		Args.beta =0.5;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255*255
		Args.sigma= 0.3 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
		Args.hsize=5.0 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
		Args.sigma_phi = 1.0 ; % the variance of regularized Gaussian kernel
		Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % heaviside函数的类型
		Args.initializeType = 'user' ;
		% 'user' 表示用自定义轮廓生成阶跃函数
		% 'SDF' 表示用经典距离函数
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		% 		% 参数组2
		% 		Args.timestep = 0.1;	% time step . default=0.005.
		% 		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		% 		Args.mu = 1;	%控制符号距离函数权值。default =1.0
		% 		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
		% 		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
		% 		Args.hsize=05 ;			% 高斯滤波器的模板大小，default=15, also means 15 x 15.
		% 		Args.sigma_phi = 0.5 ; % the variance of regularized Gaussian kernel
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
		
		
		
		
	case 'LIFgray'
		Args.timestep = 0.1;	% time step . default=0.005.
		Args.epsilon = 1.00 ;		% papramater that specifies the width of the Heaviside function. default = 1.
		Args.mu = 1;	%控制符号距离函数权值。default =1.0
		Args.beta =2;		% coefficeient of the weighted length term L(phi). default=0.5 ，or also 0.001*255^255
		Args.sigma= 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . 高斯核函数系数，越大，对初值化轮廓越鲁棒，但分割越不精确。
		Args.hsize=15;			% 高斯滤波器的模板大小，default=15 or 2*round(2*Args.sigma)*2+1, also means 15 x 15.
		Args.sigma_phi = 1.5 ; % the variance of regularized Gaussian kernel
		Args.hsize_phi = 5.0 ; % 高斯滤波器的模板大小，default=5.
		% 以下不需要改
		Args.heavisideFunctionType = '2'; % heaviside函数的类型
		Args.initializeType = 'user' ;
		% 'user' 表示用自定义轮廓生成阶跃函数
		% 'SDF' 表示用经典距离函数
		
		Args.contoursInitValue = 2;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
	case 'ACMandGMMtoEq18'
		Args.timestep = 0.10;  % time step
		Args.epsilon = 0.05; % papramater that specifies the width of the DiracDelta function.
		Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
		Args.beta = 0.50; % coefficeient of the weighted length term L(phi). default=0.5.
		Args.gamma = 0.00;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		Args.heavisideFunctionType = '2'; % 选择heaviside函数的类型
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'no';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		Args.initializeType = 'SDF' ;		% 选择嵌入函数初始化方式
		Args.contoursInitValue = 2;   % the value used for initialization contours.
		Args.numOfComponents = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
		
		
		
		
	case 'CVgray'
		Args.timestep = 0.10 ;	% time step .default=0.1.
		Args.epsilon = 1 ;			% papramater that specifies the width of the Heaviside function. default = 1.
		Args.lambda_1 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
		Args.lambda_2 = 1 ;		% coefficeient of the weighted fitting term default=1.0.
		Args.beta = 0.50 ;		% coefficeient of the weighted length term L(phi). default=0.5. ，or also 0.06*255^2
		Args.gamma = 0.00 ;		% coefficient of the weighted area term A(phi). default = 0.001*255*255 .
		
		% 以下不需要改
		Args.heavisideFunctionType = '2' ; % heaviside函数的类型
		Args.initializeType = 'SDF'  ;
		Args.contoursInitValue = 2 ;    % the value used for initialization contours.
		
		% 以下不能改
		Args.isNeedInitializingContourByLSMethod = 'yes' ;  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		
		
		
		
	case 'DRLSE'
		Args.timestep=5.0;  % time step. default is 5.0
		
		Args.isNeedInitializingContourByLSMethod = 'yes';  % 是否需要用水平集方法初始化轮廓，'yes'表示需要，'no'表示不需要。
		Args.initializeType = 'user' ;
		Args.contoursInitValue = 2;		% the value used for initialization contours.
		
		Args.heavisideFunctionType = '3'; % heaviside函数的类型 .default is '3'
		Args.mu=0.2/Args.timestep;  % coefficient of the distance regularization term R(phi) , default is 0.2/Args.timestep or 0.04.
		Args.lambda=5.0; % coefficient of the weighted length term L(phi) , default is 5.0 .
		Args.alfa=1.5;  % coefficient of the weighted area term A(phi) , default is 1.50 .
		Args.epsilon=1.5; % papramater that specifies the width of the DiracDelta function, default is 1.50 .
		Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
		Args.hsize=15 ;			% 高斯滤波器的模板大小，default is 15, also means 15 x 15.
		
		% potential function
		% use single well potential p1(s)=0.5*(s-1)^2, which is good for region-based model
		% or use double-well potential in Eq. (16), which is good for both edge and region based models
		% or use default choice of potential function .
		Args.potentialFunction = 'double-well';
		
		
		
		
	otherwise
		error('error at choose evolution method !');
end










%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 构建管理文件夹resource的结构体EachImage 和构建存储历次实验的results文件夹里的文件路径和名称的结构体 Results
Args % 打印 Args
Pros = Args; % 把Args现有的的一系列参数赋给Pros



EachImage = createEachImageStructure(Pros.foldername_EachImageBaseFolder, Pros.numUselessFiles);

input('确认文件夹里的文件数量是否正确？正确按任意键继续，否则按 Ctrl+c 终止程序。')
% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');



Results = createResultsStructure(Pros.foldername_ResultsBaseFolder ,Pros.numUselessFiles);




% for numTime = [0.1,0.2,0.6,0.7,0.8,0.9]

%% 构建本次实验的文件夹，并进行实验
Pros.foldername_eachIndexOfExperiment=dir(Results.folderpath_outputBase);	% 每次实验的文件夹列表
% num_experiment=length(Pros.foldername_eachIndexOfExperiment)-2;
Pros.index_experiment=Results.num_experiments+1;

% 生成试验编号文件夹
switch Pros.outputMode
	case 'datatime'
		% 建立一个名称为年月日时分秒的数据文件夹用于每一次的实验的输出
		switch Pros.evolutionMethod
			case 'GMM'
				Pros.foldername_experiment=[Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_numIter' num2str(Pros.numIteration_outer) '_end' num2str(Pros.proportionPixelsToEndLoop)];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_numState' num2str(Pros.numOfComponents) '_numTime' num2str(Pros.numTime) '_end' num2str(Pros.proportionPixelsToEndLoop)];
			case 'CV'
				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
			otherwise
				Pros.foldername_experiment=[Pros.evolutionMethod '_step' num2str(Pros.timestep) '_beta' num2str(Pros.beta) '_epsilon' num2str(Pros.epsilon) '_hsize' num2str(Pros.hsize) '_sigma' num2str(Pros.sigma) '_end' num2str(Pros.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_beta' num2str(Pros.beta) '_init' Pros.initializeType '_numIter' num2str(Pros.numIteration_outer) '_end' num2str(Pros.proportionPixelsToEndLoop)];
				% 				Pros.foldername_experiment=[datestr(now,'ddHHMMSS') '_' Pros.evolutionMethod '_beta' num2str(Pros.beta) '_init' Pros.initializeType '_numTime' num2str(Pros.numTime) '_end' num2str(Pros.proportionPixelsToEndLoop)];
		end
	case 'index'
		Pros.foldername_experiment = ['第' num2str(index_experiment) '次实验'];
end
Pros.folderpath_experiment=fullfile(Results.folderpath_outputBase, Pros.foldername_experiment);
mkdir(Pros.folderpath_experiment);

% 生成diary输出文件夹
Pros.foldername_diary = 'diary output';
Pros.folderpath_diary = fullfile(Pros.folderpath_experiment, Pros.foldername_diary);
if ~exist(Pros.folderpath_diary,'dir')
	mkdir(Pros.folderpath_diary );
end

%% 开启 diary 记录
Pros.filepath_diary = fullfile(Pros.folderpath_diary , ['diary.txt']);
diary(Pros.filepath_diary);
diary on;
Args % 打印 Args

% 选择需要的markType
switch Pros.markType
	case 'scribble'
		num_processedImages = EachImage.num_scribbledImage;
	case 'contour'
		num_processedImages = EachImage.num_contourImage;
	case 'original'
		num_processedImages = EachImage.num_originalImage;
	otherwise
		error('error at choose mark type !');
end



% 建立处理每个标记图像之后的Args信息文件夹路径
Pros.folderpath_ArgsOutput = fullfile(Pros.folderpath_experiment, 'Args output');
if ~exist(Pros.folderpath_ArgsOutput ,'dir');
	mkdir(Pros.folderpath_ArgsOutput);
end

% 最终分割二值图截图文件夹路径
Pros.folderpath_bwImage = fullfile(Pros.folderpath_experiment, 'bw images');
if ~exist(Pros.folderpath_bwImage,'dir')
	mkdir(Pros.folderpath_bwImage);
end

% 最终分割二值图数据文件夹路径
Pros.folderpath_bwData = fullfile(Pros.folderpath_experiment, 'bw data');
if ~exist(Pros.folderpath_bwData,'dir')
	mkdir(Pros.folderpath_bwData);
end

% 最终嵌入函数数据文件夹路径
Pros.folderpath_phiData = fullfile(Pros.folderpath_experiment, 'phi data');
if ~exist(Pros.folderpath_phiData,'dir')
	mkdir(Pros.folderpath_phiData);
end

% 建立处理每个标记图像之后的输出数据文件夹路径
Pros.folderpath_writeData=fullfile(Pros.folderpath_experiment, 'write data');
if ~exist(Pros.folderpath_writeData,'dir')
	mkdir(Pros.folderpath_writeData);
end

% 建立处理每个标记图像之后的结果图文件夹路径
Pros.folderpath_screenShot=fullfile(Pros.folderpath_experiment, 'screen shot');
if ~exist(Pros.folderpath_screenShot,'dir')
	mkdir(Pros.folderpath_screenShot);
end
% 建立处理每个标记图像的标记种子数据文件夹路径
Pros.folderpath_seeds=fullfile(Pros.folderpath_experiment, 'seeds data');
if ~exist(Pros.folderpath_seeds,'dir')
	mkdir(Pros.folderpath_seeds);
end

% 建立处理每个标记图像之后的输出评价指标 time 、 iteration 的数据文件夹路径
Pros.folderpath_evaluation=fullfile(Pros.folderpath_experiment, 'evaluation data');
if ~exist(Pros.folderpath_evaluation,'dir')
	mkdir(Pros.folderpath_evaluation);
end

% 开始记录总时间
startTotalTime = clock;
totalIteration = 0;
elipsedTime = 0;




elipsedEachTime.name=cell(num_processedImages,1);
elipsedEachTime.time =zeros(num_processedImages,1);
elipsedEachTime.iteration = zeros(num_processedImages,1);

for index_processedImage = 1:num_processedImages
	disp(['处理图像：' num2str(index_processedImage) '/' num2str(num_processedImages)]);
	
	Pros.iteration_inner=Args.iteration_inner;
	Pros.iteration_outer=Args.iteration_outer;
	
	switch Pros.markType
		case 'scribble'
			markTypeName = '涂鸦';
			Pros.filename_processedImage = EachImage.scribbledImage(index_processedImage).name;
			Pros.filepath_processedImage = EachImage.scribbledImage(index_processedImage).path;
			index_originalImage = findIndexOfOriginalImageAtEachScribbledImage(EachImage, index_processedImage, 'mark');
			
		case 'contour'
			markTypeName = '轮廓';
			Pros.filename_processedImage =EachImage.contourImage(index_processedImage).name;
			Pros.filepath_processedImage =EachImage.contourImage(index_processedImage).path;
			index_originalImage = findIndexOfOriginalImageAtEachContourImage(EachImage, index_processedImage, 'contour');
			% 读取初始化轮廓的先验信息、均值、协方差
			Pros.filename_Prior = EachImage.prior(index_processedImage).name;
			Pros.filepath_Prior = EachImage.prior(index_processedImage).path;
			load(Pros.filepath_Prior);
			Pros.filename_mu = EachImage.mu(index_processedImage).name;
			Pros.filepath_mu = EachImage.mu(index_processedImage).path;
			load(Pros.filepath_mu);
			Pros.filename_Sigma = EachImage.Sigma(index_processedImage).name;
			Pros.filepath_Sigma = EachImage.Sigma(index_processedImage).path;
			load(Pros.filepath_Sigma);
			% 读取初始化轮廓的耗费时间
			Pros.filename_time= EachImage.time(index_processedImage).name;
			Pros.filepath_time = EachImage.time(index_processedImage).path;
			load(Pros.filepath_time);
			Pros.elipsedEachTime = time0;
			% 读取初始化轮廓的初始水平集嵌入函数phi0
			Pros.filename_phi= EachImage.phi(index_processedImage).name;
			Pros.filepath_phi= EachImage.phi(index_processedImage).path;
			load(Pros.filepath_phi);
			
			
		case 'original'
			markTypeName = '原图';
			Pros.filename_processedImage = EachImage.originalImage(index_processedImage).name;
			Pros.filepath_processedImage =EachImage.originalImage(index_processedImage).path;
			index_originalImage = index_processedImage;
			
			
		otherwise
			error('error at choose mark type !');
	end
	
	% 集中设置 Pros
	Pros.filename_originalImage =  EachImage.originalImage(index_originalImage).name; % 原始图像名称;
	Pros.filepath_originalImage =EachImage.originalImage(index_originalImage).path;
	Pros.filename_ArgsOutput = [Pros.filename_processedImage(1:end-4) '_Args.mat'];
	Pros.filepath_ArgsOutput = fullfile(Pros.folderpath_ArgsOutput, Pros.filename_ArgsOutput);
	Pros.filename_bwImage = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwImage.bmp'];
	Pros.filepath_bwImage = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImage);
	Pros.filename_bwData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_bwData.mat'];
	Pros.filepath_bwData = fullfile(Pros.folderpath_bwData, Pros.filename_bwData);
	Pros.filename_phiData = [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_phiData.mat'];
	Pros.filepath_phiData = fullfile(Pros.folderpath_phiData, Pros.filename_phiData);
	Pros.filename_writeData =  [Pros.filename_processedImage(1:end-4) '_iteration_' num2str(Pros.iteration_outer) '_ExportData.mat'];
	Pros.filepath_writeData = fullfile(Pros.folderpath_writeData, Pros.filename_writeData);
	Pros.index_exportData = 1;
	
	
	%% 开始主程序
	text = ['开始图像 ' Pros.filename_originalImage ' 的' markTypeName ' ' Pros.filename_processedImage ' 的实验...'];
	if strcmp(Pros.isVoice,'yes')==1
		sp.Speak(text);
	end
	disp(text);
	
	
	%% 读取图像并显示
	image010_original = imread(Pros.filepath_originalImage);
	image010_processed = imread(Pros.filepath_processedImage);
	
	%% 显示Args
	% 设置要打印到屏幕的信息
	Args.originalImageName =Pros.filename_originalImage ;
	Args.processedImageNmae = Pros.filename_processedImage ;
	Args.nameOfExperiment =Pros.foldername_experiment ;
	Pros.Args = Args; % 把最终的Args赋给Pros，用于存储Args的数据
	disp(['原始图像' Args.originalImageName]) % 向屏幕输出原始图像名称
	disp(['处理图像' Args.processedImageNmae]) % 向屏幕输出处理图像名称
	
	% properties setting
	Pros.sizeOfImage=[size(image010_original)];
	Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
	Pros.numPixelChangedToContinue = Pros.proportionPixelsToEndLoop.*Pros.numData;	% 停机条件之一。在演化过程中如果出现两代之间的前背景的改变的像素数量小于这个值，就允许继续循环
	
	
	%
	% 		%% initializing a contour of image
	% 			switch Pros.initMethod
	% 				case 'circle'
	% 					% 用一个大圆圈生成经典距离函数
	% 					Pros.circleCenterX=Pros.sizeOfImage(1)/2;
	% 					Pros.circleCenterY=Pros.sizeOfImage(2)/2;
	% 					phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
	%
	% 				otherwise
	% 			end
	%
	
	
	%% start level set evolution
	switch Pros.evolutionMethod
		case 'ACMGMM'
			%% ACM&GMM new： 借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(25)
			% 轮廓演化一代得到新一代轮廓
			[ Pros, phi] = evolution_ACMandGMMnew_pi2(Pros,  image010_original, image010_processed, phi0, Prior0, mu0, Sigma0);
			
		case 'ACMGMMpi1'
			%% ACM&GMM pi 1：借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(23)
			% 轮廓演化一代得到新一代轮廓
			[ Pros, phi] = evolution_ACMandGMM_pi1(Pros,  image010_original, image010_processed);
			
		case 'ACMGMMpi2'
			%% ACM&GMM pi 2：借鉴[1] Guowei Gao等人的方法，计算水平集演化，先验计算用式(25)
			% 轮廓演化一代得到新一代轮廓
			[ Pros, phi] = evolution_ACMandGMM_pi2(Pros,  image010_original, image010_processed);
			
		case 'ACMandGM'
			%% ACM&GM： [5]第二节的方法，计算水平集演化
			[ Pros, phi ] = evolution_ACMandGM(Pros,  image010_original, image010_processed, phi0);
			
		case 'CV'
			%% CV：使用扩展到彩色空间的CV模型的方法，计算水平集演化
			%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
			%   Author: Chunming Li, all right reserved
			%   email: li_chunming@hotmail.com
			%   URL:   http://www.engr.uconn.edu/~cmli
			[ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV(Pros,  image010_original, image010_processed, phi0);   % update level set function
			
			
		case 'CVgray'
			%% CV gray：使用传统的处理灰度图像的CV模型的方法，计算水平集演化
			%   Matlad code implementing Chan-Vese model in the paper 'Active Contours Without Edges'
			%   Author: Chunming Li, all right reserved
			%   email: li_chunming@hotmail.com
			%   URL:   http://www.engr.uconn.edu/~cmli
			[ Pros, phi, heaviside_phi, dirac_phi]  = evolution_CV_gray(Pros,  image010_original, image010_processed, phi0);   % update level set function
			
			
		case 'GMM'
			%% GMM：使用GMM的二相分割
			[Pros, phi] = evolution_GMM(Pros, image010_original, image010_processed, Prior0, mu0, Sigma0);
			
		case 'ACMandGMMtoEq18'
			%% ACMandGMMtoEq18：此方案是借鉴[1]的方法，但是不引入关于(23)(25)式的先验信息，而只用到(18)：
			% 轮廓演化一代得到新一代轮廓
			[Pros, phi ] = evolution_ACMandGMMtoEq18(Pros,  image010_original, image010_processed);
			
			
			
		case 'LBF'
			%% LBF：使用改进为处理彩色图像的LBF方法，计算水平集演化
			%本程序用来演化水平集函数，详见文章：C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
			%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
			%phi为水平集函数，I为图像,Ksigma为核函数,nu长度权值,timestep时间步长,mu符号距离函数权值
			%lambda1和lambda2为权值，epsilon控制阶跃和冲击函数
			%By Liushigang.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LBFgray'
			%% LBF gray：使用传统的处理灰度图像的LBF方法，计算水平集演化
			%本程序用来演化水平集函数，详见文章：C. Li, C. Kao, J.C. Gore, Z. Ding. Minimization of region-scalable fitting energy for image segmentation.
			%IEEE Transaction on Image Processing, 2008, 17(10):1940-1949.
			%phi为水平集函数，I为图像,Ksigma为核函数,nu长度权值,timestep时间步长,mu符号距离函数权值
			%lambda1和lambda2为权值，epsilon控制阶跃和冲击函数
			%By Liushigang.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LBF_gray(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LIF'
			%% LIF：使用改进为处理彩色图像的LIF方法，计算水平集演化
			% This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
			%    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
			% Author: Kaihua Zhang, all rights reserved
			% E-mail: zhkhua@mail.ustc.edu.cn
			% http://www4.comp.polyu.edu.hk/~cslzhang/
			%  Notes:
			%   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
			%   2. Intial contour should be set properly.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF(Pros, image010_original, image010_processed, phi0);
			
			
		case 'LIFgray'
			%% LIF gray：使用传统的处理灰度图像的LIF方法，计算水平集演化
			% This Matlab file demomstrates a level set algorithm based on Kaihua Zhang et al's paper:
			%    "Active contours driven by local image fitting energy" published by pattern recognition (2009)
			% Author: Kaihua Zhang, all rights reserved
			% E-mail: zhkhua@mail.ustc.edu.cn
			% http://www4.comp.polyu.edu.hk/~cslzhang/
			%  Notes:
			%   1. Some parameters may need to be modified for different types of images. Please contact the author if any problem regarding the choice of parameters.
			%   2. Intial contour should be set properly.
			[ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF_gray(Pros, image010_original, image010_processed, phi0);
			
			
		case 'DRLSE'
			%% DRLSE：使用李春明的DRLSE的方法，计算水平集演化
			%% generate edge indicator function.
			
			image010_gray =256.* image010_processed(:,:,1);
			G=fspecial('gaussian',Args.hsize ,Args.sigma);
			image010_smooth=conv2(image010_gray,G,'same');  % smooth image by Gaussiin convolution
			[Ix,Iy]=gradient(image010_smooth);
			f=Ix.^2+Iy.^2;
			g=1./(1+f);  % edge indicator function.
			
			% 初始化轮廓
			phi = phi0;
			
			[Pros, phi] = visualizeContours_DRLSE( phi, image010_original, image010_data, Pros,Results );
			
			while Pros.iteration_outer<=Args.numIteration_outer
				%% 轮廓演化一代得到新一代轮廓
				[Pros, phi] = evolution_DRLSE( phi, g, Args,Pros );
				
				%% visualization
				Pros = visualizeContours_DRLSE( phi, image010,Args,Pros,Results );
				%%
				Pros.iteration_outer=Pros.iteration_outer+1;
			end
			
			
		otherwise
			error('error at choose evolution method !');
	end  % end this evolution method
	
	%% 计时每个图像处理时间
	elipsedEachTime(index_processedImage).name = Pros.filename_originalImage(1:end-4) ;
	elipsedEachTime(index_processedImage).time = Pros.elipsedEachTime;
	elipsedEachTime(index_processedImage).iteration = Pros.iteration_outer-1;
	elipsedTime = elipsedTime+elipsedEachTime(index_processedImage).time ;
	remainingTime = (elipsedTime/index_processedImage)*(num_processedImages - index_processedImage);
	totalIteration = totalIteration+Pros.iteration_outer-1;
	disp(['单个图像处理时间： ' num2str(elipsedEachTime(index_processedImage).time) ' 秒'])
	disp(['演化代数： ' num2str(elipsedEachTime(index_processedImage).iteration)])
	disp(['预计剩余时间： ' num2str(remainingTime) ' 秒'])
	
	%% 写出关键的数据
	Pros.filename_bwImageEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod  '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwImage.bmp'];
	Pros.filepath_bwImageEnd = fullfile(Pros.folderpath_bwImage, Pros.filename_bwImageEnd);
	Pros.filename_bwDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_bwData.mat'];
	Pros.filepath_bwDataEnd = fullfile(Pros.folderpath_bwData, Pros.filename_bwDataEnd);
	Pros.filename_phiDataEnd = [Pros.filename_processedImage(1:end-4) '_' Pros.evolutionMethod '_iter' num2str(Pros.iteration_outer-1) '_time' num2str(Pros.elipsedEachTime) '_phiData.mat'];
	Pros.filepath_phiDataEnd = fullfile(Pros.folderpath_phiData, Pros.filename_phiDataEnd);
	
	% 写出最终嵌入函数数据
	phiData = reshape(phi,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
	%     save(Pros.filepath_phiDataEnd,'phiData');
	if exist(Pros.filepath_phiDataEnd,'file')
		disp(['已保存最终嵌入函数数据 ' Pros.filename_phiDataEnd]);
	else
		disp(['未保存最终嵌入函数数据 ' Pros.filename_phiDataEnd]);
	end
	
	% 生成\phi 分割得到的二值图数据
	bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
	bwData(phiData>=0)=1;
	bwData = im2bw(bwData);
	% 保存最终分割二值图
	imwrite(bwData, Pros.filepath_bwImageEnd,'bmp');
	if exist(Pros.filepath_bwImage,'file')
		disp(['已保存最终分割二值图 ' Pros.filename_bwImageEnd]);
	else
		disp(['未保存最终分割二值图 ' Pros.filename_bwImageEnd]);
	end
	% 写出最终分割二值图数据
	%     save(Pros.filepath_bwDataEnd,'bwData');
	%     if exist(Pros.filepath_bwDataEnd,'file')
	%         disp(['已保存最终分割二值图数据 ' Pros.filename_bwDataEnd]);
	%     else
	%         disp(['未保存最终分割二值图数据 ' Pros.filename_bwDataEnd]);
	%     end
	
	
	disp(' ')
	
	%% 存储 Args
	Args.realTime = elipsedEachTime(index_processedImage).time;
	Args.iterations =  elipsedEachTime(index_processedImage).iteration;
	save(Pros.filepath_ArgsOutput, 'Args'); % 保存Args成mat文件
	
end % end this marked image

%% save data of elipsed total time and average iteration and each elipsed time and iteration.
averageIteration = totalIteration/num_processedImages;
Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time' num2str(elipsedTime) '_iter' num2str(averageIteration) '.mat']);
% Pros.filepath_elipsedEachTime = fullfile(Pros.folderpath_evaluation , ['time.mat']);
elipsedEachTime=struct2table(elipsedEachTime);
save(Pros.filepath_elipsedEachTime,'elipsedEachTime');
disp(' ')

%% 程序结束提醒
elapsedTotalTime = etime(clock,startTotalTime);
disp(['平均演化代数： ' num2str(averageIteration)])
disp(['运行时间：' num2str(elapsedTotalTime) '秒。'])
text=['程序运行完毕。'];
% text=['程序运行完毕。运行时间：' num2str(elapsedTotalTime) '秒。'];
disp(text);
sp.Speak(text);

%% 停止记录公共窗口输出的数据并保存
diary off;





