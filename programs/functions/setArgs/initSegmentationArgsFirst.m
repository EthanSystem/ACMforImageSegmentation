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
    ...'LBF'							LBF方法，用于彩色图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIF'								LIF方法，用于彩色图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    ...'CVgray'											CV模型方法。reference: Chan, T.F. and L.A. Vese, Active contours without edges. IEEE Transactions on Image Processing, 2001. 10(2): p. 266-77.
    ...'LBFgray'							LBF方法，用于灰度图 Li, C. and C. Y. Kao, et al. (2007). Implicit Active Contours Driven by Local Binary Fitting Energy. Computer Vision and Pattern Recognition, 2007. CVPR '07. IEEE Conference on.
    ...'LIFgray'								LIF方法，用于灰度图 Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.
    
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K\original resources';
Args.folderpath_EachImageInitBaseFolder = '.\data\resources\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
Args.folderpath_ResultsBaseFolder = '.\data\resources\MSRA1K\segmentations';

Args.evolutionMethod = 'semiACMGMMSP_1_2' ;	% 选择演化模型

Args.markType = 'scribble' ;	% 选择标记类型，表示用什么类型的交互式标记进行分割。可选 'original' 'contour' 'scribble'。'original' 表示不用交互式标记，直接用原图。'contour' 表示用别的方式初始化的轮廓图作为初始化。'scribble' 表示用交互式
Args.initMethod = 'scribbled_kmeans' ; % 选择初始化类型，表示用什么类型的初始化方法。可选 'circle' 'kmeans' 'kmeans+ACMGMM' 'circle+ACMGMM'
Args.maxIterOfKmeans = 100; % 用 k-means 初始化的时候的最大迭代次数。


Args.isNotVisiualEvolutionAtAll = 'yes' ; % 程序运行过程中是否完全不可视化中间过程和保存中间过程图 。如果 'yes'，那么就不可视化和保存中间过程图。默认 'yes'
Args.isVisualEvolution = 'no' ;	% 程序运行过程中是否可视化显示结果图，但是最终结果图还是要可视化和保存的。默认 'no'
Args.isVisibleVisualEvolution = 'off' ;  % % 程序运行过程中是否可视化显示结果图，但是结果图还是要保存的。默认 'off'
Args.periodOfVisual = 1 ;	% 可视化显示结果图的迭代次数周期，即每隔几代显示一次结果图。默认 10

Args.isNotWriteDataAtAll = 'yes' ; % 程序运行过程中产生的结果数据是否保存，如果 'yes'，那么就不保存结果数据，但是最终的二值图图像还是会保存的。默认 'yes'
Args.isWriteData = 'no' ;		% 程序运行过程中产生的结果数据是否保存，但是最终结果数据还是要保存的。默认 'no'
Args.periodOfWriteData = 1 ; % 写数据的迭代次数周期，即每隔几代保存一次程序运行过程中产生的那一代的数据。默认 10

Args.isTestOnlyFewImages = 'no' ; % 每种方法是否运行的时候只处理前几张图像，以作为测试。默认 'no'。
Args.numImagesToTest = 20 ; % 每种方法测试数据库的前几张图像。默认 3, 10。

Args.isRunArrayProcessedImages = 'no' ; % 每种方法是否只运行在数列里的一部分图像。
Args.arrayProcessedImages = [3] ; % 每种方法运行的时候，处理数列里的一部分图像。

Args.isVoice = 'no' ;		% 程序运行过程中是否声音提示，默认 'no'

Args.circleRadius = 100 ; % setting radius of contour circle if you use SDF to initiate a phi function

% 设置停机条件
Args.proportionPixelsToEndLoop = 0.00100 ; % 设置演化循环停止条件：当两次相邻迭代之间，前背景的像素数改变的数量占所有像素数量的比例值小于设定值时则停止。值域[0,1]。默认 0.00100 。
Args.numIteration_inner=1 ;				% 内循环次数，default = 1
Args.iteration_inner=1 ;						% 内循环初始值，default = 1
Args.numIteration_outer= 1000  ;		% 外循环次数，default = 1000
Args.iteration_outer=1 ;						% 外循环初始值，default = 1
Args.numTime = 3.0 ;			% 每个图像处理的最大固定时间，如果超过这个时间则在该迭代结束之后停止循环。

Args.outputMode = 'datatime';	% 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index' 表示实验文件夹名称是编号。默认 'datatime' 。推荐用默认值。

Args.numUselessFiles = 0;   % 有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除无用文件的数量。但是此功能有bug。

% 是否设置以下参数有待探究
% 轮廓的初始化
% 可以用任一方式初始化，'BOX'、'USER' 二者选择一个
Args.contourType='USER';
Args.boxWidth=20;
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.isMinMaxInitContours = 'yes';   % 是否设置水平集嵌入函数的初始上下限值
Args.contoursInitMinValue = -1;   % 水平集初始嵌入函数的下限值。
Args.contoursInitMaxValue = 1;   % 水平集初始嵌入函数的上限值。

Args.smallNumber=realmin+1E-20;  % 允许添加的防止除法运算误差最小数。
