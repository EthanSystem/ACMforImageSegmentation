function [Args] = setExtractArgs( Args )
% setExtractImagesArgs 用于设置提取图像函数的参数
%   此处显示详细说明
%% 简介
% collectImagesForExtractByOtherIndicator.m 实现提取各个方法的图像以及真值图到指定文件夹以便于人工筛选
% 提取指定的文件和文件夹的模式有如下三种：
% 模式1 表示在带有较强的评价指标的限制条件下的第一轮筛选下，提取相应图像。
% 模式2 表示在带有较弱的评价指标的限制条件下的第一轮筛选下，提取相应图像。
% 模式3 表示无筛选的情况下，提取相应图像。
% 注意程序运行时会提示要求输入实验组！

%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = Args.mode ; % 提取指定的文件和文件夹的模式，如简介所述。
Args.folderpath_reourcesDatasets = Args.folderpath_reourcesDatasets;    % 基础资源文件（原图、真值图、标记图）的基本路径
Args.folderpath_initDatasets = Args.folderpath_initDatasets;    % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
Args.folderpath_ResultsBaseFolder = Args.folderpath_ResultsBaseFolder; % 用于提取文件的结构体 Results 的基本路径。
% Args.folderpath_finalResultsBaseFolder = '.\data\evaluation\circleACMGMM 5-28挑出来\要做kmeans+AMCGMM聚类的\end0.001'; % 用于提取文件的结构体 Results 的基本路径。
Args.folderpath_outputBase = Args.folderpath_outputBase; % 提取文件的目标文件夹

Args.outputMode =Args.outputMode  ;	 % 指定存放这次实验的文件夹的文件名称显示类型。可选 'datatime' 'index'。'datatime' 表示实验文件夹名称是日期时间；'index'表示实验文件夹名称是编号。默认 'datatime'。推荐用默认值。
Args.num_scribble = Args.num_scribble ; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.isVisual = Args.isVisual ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
Args.numUselessFiles = Args.numUselessFiles; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
Args.ratioOfGood = Args.ratioOfGood; % 定义好的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.85
Args.ratioOfBad =Args.ratioOfBad  ; % 定义差的图像的所占的指标的值的比例阈值。值域[0,1]，默认 0.65
Args.ratioOfBetter = Args.ratioOfBetter; % 两种方法比较时，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认 0.3
Args.ratioOfBetterAtBothGood =Args.ratioOfBetterAtBothGood; % 两种方法比较时，两种方法都好的情况下，方法A要比方法B的指标的值的比例要大于等于该值，才认为明显好。值域[0,1]，默认0.1
Args.ratioOfRegion = Args.ratioOfRegion; % 实验组和对照组比较时，实验组效果比对照组效果不好的图像数量 占 实验组效果比对照组效果好的图像数量 的比例。
Args.ratioOfRand =Args.ratioOfRand ; % 控制实验组和对照组比较时，实验组效果好的图像数量占总图像数量的比例的随机范围。
Args.numImagesShow = Args.numImagesShow ; % 要提取的图像的最大限制数量。



end

