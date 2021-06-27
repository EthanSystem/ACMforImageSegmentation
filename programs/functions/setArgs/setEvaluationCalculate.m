function [Args]=setEvaluationCalculate(Args)
%% 设置评估计算函数需要的参数
%% 用户输入初始参数 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.folderpath_resourcesBaseFolder = Args.folderpath_resourcesBaseFolder; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_initBaseFolder =Args.folderpath_initBaseFolder; % 用于计算文件的结构体 EachImage 的基本路径
Args.folderpath_ResultsBaseFolder = Args.folderpath_ResultsBaseFolder; % 用于计算文件的结构体 Results 的基本路径。
Args.beta =Args.beta; % the F_1 指标是 F-beta 指标在 beta =1 时的特例。
Args.num_scribble=Args.num_scribble; % 所有待处理的图像的标记总数。由于目前暂时不考虑不同标记对分割效果的影响，而仅仅用一张图像一种标记，因此目前手动设置为1。
Args.numUselessFiles = Args.numUselessFiles; % 要处理的图像数量。有时候存储图片的文件夹除了有图像文件，还有可能是系统文件，会被误处理，因此需要手动排除
Args.mode = Args.mode ; % ，'1' 表示不反转图像；'2' 表示根据几个指标同时判定是否反转图像；'3' 表示根据 查准率P 指标判定是否反转图像；

end

