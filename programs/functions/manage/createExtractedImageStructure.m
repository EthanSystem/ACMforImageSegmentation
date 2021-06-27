function [ ExtractedImage ] = createExtractedImageStructure( baseFolder, numUselessFiles )
%CREATEEXTRACTEDIMAGESTRUCTURE �����ṹ�� ExtractedImage
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% ExtractedImage������һ���ṹ��

ExtractedImage.folderpath_datasets =[ baseFolder ];	% ����·��
if ~exist(ExtractedImage.folderpath_datasets,'dir')
	mkdir(ExtractedImage.folderpath_datasets);
end

%% �ļ��� contour images ����Ϣ
ExtractedImage.folderpath_contourImage = fullfile(ExtractedImage.folderpath_datasets, 'contour images');
if ~exist(ExtractedImage.folderpath_contourImage,'dir')
	mkdir(ExtractedImage.folderpath_contourImage);
end
% ��ȡÿһ�����ļ��еĳ�ʼ����������ֵͼ��Ϣ
ExtractedImage.contourImage = dir([ExtractedImage.folderpath_contourImage '\*.bmp']);
ExtractedImage.num_contourImage= numel(ExtractedImage.contourImage)-numUselessFiles;
disp(['�ļ��� contour images �� ' num2str(ExtractedImage.num_contourImage) ' ���ļ�'])
if ExtractedImage.num_contourImage ~=0
	for index_contourImage = 1:ExtractedImage.num_contourImage
		ExtractedImage.contourImage(index_contourImage).path = fullfile(ExtractedImage.folderpath_contourImage, ExtractedImage.contourImage(index_contourImage).name);
	end
else
	disp(['�ļ��� ' ExtractedImage.folderpath_contourImage ' û�����ն�ֵͼ��ͼ�ļ�...']);
end

%% �ļ��� ground truth bw images ����Ϣ
ExtractedImage.folderpath_groundTruthBwImage = fullfile(ExtractedImage.folderpath_datasets, 'ground truth bw images');
if ~exist(ExtractedImage.folderpath_groundTruthBwImage,'dir')
	mkdir(ExtractedImage.folderpath_groundTruthBwImage);
end
% ��ȡÿһ�����ļ��еĴ𰸶�ֵͼ��ͼ��Ϣ
ExtractedImage.groundTruthBwImage = dir([ExtractedImage.folderpath_groundTruthBwImage '\*.bmp']);
ExtractedImage.num_groundTruthBwImage= numel(ExtractedImage.groundTruthBwImage)-numUselessFiles;
disp(['�ļ��� ground truth bw images �� ' num2str(ExtractedImage.num_groundTruthBwImage) ' ���ļ�'])
if ExtractedImage.num_groundTruthBwImage ~=0
	for index_groundTruthBwImage = 1:ExtractedImage.num_groundTruthBwImage
		ExtractedImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(ExtractedImage.folderpath_groundTruthBwImage, ExtractedImage.groundTruthBwImage(index_groundTruthBwImage).name);
	end
else
	disp(['�ļ��� ' ExtractedImage.folderpath_groundTruthBwImage ' û�д𰸶�ֵͼ��ͼ�ļ�...']);
end

%% �ļ��� original images ����Ϣ
ExtractedImage.folderpath_originalImage = fullfile(ExtractedImage.folderpath_datasets, 'original images');
if ~exist(ExtractedImage.folderpath_originalImage,'dir')
	mkdir(ExtractedImage.folderpath_originalImage);
end
% ��ȡÿһ�����ļ��е�ԭʼͼ����Ϣ
ExtractedImage.originalImage = dir([ExtractedImage.folderpath_originalImage '\*.jpg']);
ExtractedImage.num_originalImage= numel(ExtractedImage.originalImage)-numUselessFiles;
disp(['�ļ��� original images �� ' num2str(ExtractedImage.num_originalImage) ' ���ļ�'])
if ExtractedImage.num_originalImage ~=0
	for index_originalImage = 1:ExtractedImage.num_originalImage
		ExtractedImage.originalImage(index_originalImage).path = fullfile(ExtractedImage.folderpath_originalImage, ExtractedImage.originalImage(index_originalImage).name);
	end
else
	disp(['�ļ��� ' ExtractedImage.folderpath_originalImage ' û��ԭʼͼ���ļ�...']);
end

%% �ļ��� scribbled images ����Ϣ
ExtractedImage.folderpath_scribbledImage = fullfile(ExtractedImage.folderpath_datasets, 'scribbled images');
if ~exist(ExtractedImage.folderpath_scribbledImage,'dir')
	mkdir(ExtractedImage.folderpath_scribbledImage);
end
% ��ȡÿһ�����ļ��еĴ���ǵ�ԭʼͼ���ļ���Ϣ
ExtractedImage.scribbledImage = dir([ExtractedImage.folderpath_scribbledImage '\*.bmp']);
ExtractedImage.num_scribbledImage= numel(ExtractedImage.scribbledImage)-numUselessFiles;
disp(['�ļ��� scribbled images �� ' num2str(ExtractedImage.num_scribbledImage) ' ���ļ�'])
if ExtractedImage.num_scribbledImage ~=0
	for index_scribbledImage = 1:ExtractedImage.num_scribbledImage
		ExtractedImage.scribbledImage(index_scribbledImage).path = fullfile(ExtractedImage.folderpath_scribbledImage, ExtractedImage.scribbledImage(index_scribbledImage).name);
	end
else
	disp(['�ļ��� ' ExtractedImage.folderpath_scribbledImage ' û�д���ǵ�ԭʼͼ���ļ�...']);
end


end





