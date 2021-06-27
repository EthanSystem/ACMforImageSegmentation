%% 简介
% 提取指定文件夹的所有与原图相关的图像（相关的真值图、各方法分割出来的二值图）到同一个文件夹用于下一次筛选。

%% 简介
% collectImagesForExtractByHuman.m 实现提取各个方法的图像以及真值图到指定文件夹以便于人工筛选
% 模式1 提取相应图像，用于下一轮筛选。
% 模式2 提取相应图像，用于作为下一次图像分割和分析的图像集合。
% 模式3 提取相应图像，用于作为下一次用新的初始化轮廓进行分割和分析的图像集合。

%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;
Args.folderpath_EachImageResourcesBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\original resources' ; % 基础资源文件（原图、真值图、标记图）的基本路径
Args.folderpath_EachImageInitBaseFolder='.\data\ACMGMMSEMI\MSRA1K\init resources'; % 基础初始化文件（各种初始化方法生成的如初始轮廓二值图、各参数、时间参数等）的基本路径
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations' ; % 用于提取文件的结构体 Results 的基本路径。
Args.folderpath_extractedImageBaseFolder = '.\data\ACMGMMSEMI\筛1\original resources' ; % 待提取的文件的图像所在路径。
% for mode = '1' or '2' :
Args.folderpath_output_ResourcesBaseFolder = '.\data\ACMGMMSEMI\筛1\original resources' ; % 输出的 resources 图像的路径
Args.folderpath_output_InitBaseFolder = '.\data\ACMGMMSEMI\筛1\init resources' ; % 输出的 resources 图像的路径
% for mode = '2' :
Args.folderpath_ouput_segmentations = '.\data\ACMGMMSEMI\筛1\segmentations' ; % 输出的 evaluation 图像的路径
Args.isVisual = 'no' ;  % 绘制过程不可视化，程序结束后自行查看结果。 'yes'表示绘制过程中可视化 ，'no'表示绘制过程中不可视化。默认'no'
Args.numUselessFiles = 0; % 要排除的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件会被误处理，因此需要手动排除。
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
