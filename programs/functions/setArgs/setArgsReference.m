function [ output_args ] = setArgsReference( input_args )
%SETARGS 此处显示有关此函数的摘要
%   will be useless in future version.

%% 用户输入初始参数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Args 结构体里的字段表示程序运行前手动设置的参数

% 选择演化模式
...'ACMandSemisupervised'       基于 [1] ，且引入交互式的新方法
    ...'ACMGMM'		基于[1]的新方法
    ... 'ACMGMMpi1'                          基于[1]的方法的变种的第一种先验信息的计算方式
    ...'ACMGMMpi2'					基于[1]的方法的变种的第二种先验信息的计算方式
    ...'ACMandGM'							导师提供的第二章部分的方法。。。
    ...'ACMandGMMtoEq18'                      借鉴[1]的方法，但是不引入关于(23)(25)式的先验信息，而只用到(18)
    ...'GMM'										GMM 的传统方法
    ...'DRLSE'									    DRLSE模型。此方法由以下提供 C. Li, C. Xu, C. Gui, M. D. Fox, "Distance Regularized Level Set Evolution and Its Application to Image Segmentation", IEEE Trans. Image Processing, vol. 19 (12), pp.3243-3254, 2010....的方法
    ...'CV'											CV模型方法，用于彩色图。Chan, T. F. and B. Y. Sandberg, et al. (2000). "Active Contours without Edges for Vector-Valued Images." Journal of Visual Communication and Image Representation 11 (2): 130-141.
    ...'LBF'							LBF方法，用于彩色图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIF'								LIF方法，用于彩色图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    ...'CVgray'											CV模型方法。reference: Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
    ...'LBFgray'							LBF方法，用于灰度图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIFgray'								LIF方法，用于灰度图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    Args.evolutionMethod = 'ACMandSemisupervised' ;	% 选择演化模型

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


end

