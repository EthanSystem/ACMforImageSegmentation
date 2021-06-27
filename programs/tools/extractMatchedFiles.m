%% 功能简介
% 提取两个文件夹里面名字匹配的文件到新的两个文件夹里面。


clear all;
close all;
clc;

folderpath_gt_source='D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\Resource\图像、真值、评估\binarymasks\binarymasks\' ;
folderpath_img_source='D:\EthanLin\CoreFiles\ProjectsFile\Study\PostGraduate\Projects\ImageSegementation\Resource\图像、真值、评估\ImageB\Image\8\' ;
folderpath_gt_destination='.\test\8_gt' ;
folderpath_img_destination='.\test\8_img' ;
mkdir(folderpath_gt_destination);
mkdir(folderpath_img_destination);
file_gt=dir([folderpath_gt_source '*.bmp']);
file_img = dir([folderpath_img_source '*.jpg']);

for i=1:numel(file_gt)
	[~,file_gt(i).onlyname,~] = fileparts(file_gt(i).name);
end
for i=1:numel(file_img)
	[~,file_img(i).onlyname,~] = fileparts(file_img(i).name);
end

cell_file_gt = {file_gt(:).onlyname};
cell_file_img = {file_img(:).onlyname};

temp010=cell(numel(file_gt),numel(file_img));
for i=1:numel(cell_file_gt)
	for j=1:numel(cell_file_img)
		temp010(i,j) = strfind(cell_file_gt(i),cell_file_img(j));
	end
end

temp020=~cellfun('isempty',temp010);

mapGtToImg=zeros(numel(cell_file_gt),1);
for i=1:numel(cell_file_gt)
	if find(temp020(i,:),1)
		mapGtToImg(i)=find(temp020(i,:)==1);
	end
end

for i=1:length(mapGtToImg)
	if mapGtToImg(i)
		filename_gt=file_gt(i).name;
		filename_img=file_img(mapGtToImg(i)).name;
		filepath_gt=fullfile(folderpath_gt_source,filename_gt);
		filepath_img=fullfile(folderpath_img_source,filename_img);
		copyfile(filepath_gt, folderpath_gt_destination);
		copyfile(filepath_img, folderpath_img_destination);
	end
end

sp=actxserver('SAPI.SpVoice');
text=['程序运行完毕！'];
sp.Speak(text);
disp(text);




