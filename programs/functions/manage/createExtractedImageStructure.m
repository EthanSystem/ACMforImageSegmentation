function [ ExtractedImage ] = createExtractedImageStructure( baseFolder, numUselessFiles )
%CREATEEXTRACTEDIMAGESTRUCTURE 创建结构体 ExtractedImage
%   input:
% numUselessFiles：要减去的无用的文件数。针对Windows系统的图像文件夹里的文件“Thumbs.db”
% output:
% ExtractedImage：返回一个结构体

ExtractedImage.folderpath_datasets =[ baseFolder ];	% 基本路径
if ~exist(ExtractedImage.folderpath_datasets,'dir')
	mkdir(ExtractedImage.folderpath_datasets);
end

%% 文件夹 contour images 的信息
ExtractedImage.folderpath_contourImage = fullfile(ExtractedImage.folderpath_datasets, 'contour images');
if ~exist(ExtractedImage.folderpath_contourImage,'dir')
	mkdir(ExtractedImage.folderpath_contourImage);
end
% 获取每一个子文件夹的初始轮廓轮廓二值图信息
ExtractedImage.contourImage = dir([ExtractedImage.folderpath_contourImage '\*.bmp']);
ExtractedImage.num_contourImage= numel(ExtractedImage.contourImage)-numUselessFiles;
disp(['文件夹 contour images 有 ' num2str(ExtractedImage.num_contourImage) ' 个文件'])
if ExtractedImage.num_contourImage ~=0
	for index_contourImage = 1:ExtractedImage.num_contourImage
		ExtractedImage.contourImage(index_contourImage).path = fullfile(ExtractedImage.folderpath_contourImage, ExtractedImage.contourImage(index_contourImage).name);
	end
else
	disp(['文件夹 ' ExtractedImage.folderpath_contourImage ' 没有最终二值图截图文件...']);
end

%% 文件夹 ground truth bw images 的信息
ExtractedImage.folderpath_groundTruthBwImage = fullfile(ExtractedImage.folderpath_datasets, 'ground truth bw images');
if ~exist(ExtractedImage.folderpath_groundTruthBwImage,'dir')
	mkdir(ExtractedImage.folderpath_groundTruthBwImage);
end
% 获取每一个子文件夹的答案二值图截图信息
ExtractedImage.groundTruthBwImage = dir([ExtractedImage.folderpath_groundTruthBwImage '\*.bmp']);
ExtractedImage.num_groundTruthBwImage= numel(ExtractedImage.groundTruthBwImage)-numUselessFiles;
disp(['文件夹 ground truth bw images 有 ' num2str(ExtractedImage.num_groundTruthBwImage) ' 个文件'])
if ExtractedImage.num_groundTruthBwImage ~=0
	for index_groundTruthBwImage = 1:ExtractedImage.num_groundTruthBwImage
		ExtractedImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(ExtractedImage.folderpath_groundTruthBwImage, ExtractedImage.groundTruthBwImage(index_groundTruthBwImage).name);
	end
else
	disp(['文件夹 ' ExtractedImage.folderpath_groundTruthBwImage ' 没有答案二值图截图文件...']);
end

%% 文件夹 original images 的信息
ExtractedImage.folderpath_originalImage = fullfile(ExtractedImage.folderpath_datasets, 'original images');
if ~exist(ExtractedImage.folderpath_originalImage,'dir')
	mkdir(ExtractedImage.folderpath_originalImage);
end
% 获取每一个子文件夹的原始图像信息
ExtractedImage.originalImage = dir([ExtractedImage.folderpath_originalImage '\*.jpg']);
ExtractedImage.num_originalImage= numel(ExtractedImage.originalImage)-numUselessFiles;
disp(['文件夹 original images 有 ' num2str(ExtractedImage.num_originalImage) ' 个文件'])
if ExtractedImage.num_originalImage ~=0
	for index_originalImage = 1:ExtractedImage.num_originalImage
		ExtractedImage.originalImage(index_originalImage).path = fullfile(ExtractedImage.folderpath_originalImage, ExtractedImage.originalImage(index_originalImage).name);
	end
else
	disp(['文件夹 ' ExtractedImage.folderpath_originalImage ' 没有原始图像文件...']);
end

%% 文件夹 scribbled images 的信息
ExtractedImage.folderpath_scribbledImage = fullfile(ExtractedImage.folderpath_datasets, 'scribbled images');
if ~exist(ExtractedImage.folderpath_scribbledImage,'dir')
	mkdir(ExtractedImage.folderpath_scribbledImage);
end
% 获取每一个子文件夹的带标记的原始图像文件信息
ExtractedImage.scribbledImage = dir([ExtractedImage.folderpath_scribbledImage '\*.bmp']);
ExtractedImage.num_scribbledImage= numel(ExtractedImage.scribbledImage)-numUselessFiles;
disp(['文件夹 scribbled images 有 ' num2str(ExtractedImage.num_scribbledImage) ' 个文件'])
if ExtractedImage.num_scribbledImage ~=0
	for index_scribbledImage = 1:ExtractedImage.num_scribbledImage
		ExtractedImage.scribbledImage(index_scribbledImage).path = fullfile(ExtractedImage.folderpath_scribbledImage, ExtractedImage.scribbledImage(index_scribbledImage).name);
	end
else
	disp(['文件夹 ' ExtractedImage.folderpath_scribbledImage ' 没有带标记的原始图像文件...']);
end


end





